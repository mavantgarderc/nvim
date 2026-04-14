-- lua/lsp/codeaction.lua
-- Smart code action manager with preview, filtering, history, and monorepo grouping

local M = {}

local monorepo = require("lsp.monorepo")

---@class CodeActionEntry
---@field action lsp.CodeAction
---@field client_id integer
---@field client_name string
---@field package_name string|nil

local commands_registered = false

M._history = {}
M._config = {
  max_history = 50,
  preferred_kinds = {
    "quickfix",
    "refactor.extract",
    "refactor.inline",
    "refactor.rewrite",
    "source.organizeImports",
    "source.fixAll",
  },
}

--- Resolve package name for a buffer
---@param bufnr number
---@return string
local function resolve_package(bufnr)
  local fname = vim.api.nvim_buf_get_name(bufnr)
  if fname == "" then return "unknown" end
  local root = monorepo.find_monorepo_root(vim.fn.fnamemodify(fname, ":h"))
  if not root then return "workspace" end
  local rel = fname:sub(#root + 2)
  local pkg = rel:match("^packages/([^/]+)") or rel:match("^apps/([^/]+)") or "root"
  return pkg
end

--- Gather code actions from all attached clients
---@param bufnr number
---@param callback fun(entries: CodeActionEntry[])
function M.gather(bufnr, callback)
  bufnr = bufnr or vim.api.nvim_get_current_buf()

  local params = vim.lsp.util.make_range_params()
  params.context = {
    diagnostics = vim.diagnostic.get(bufnr),
    only = nil,
    triggerKind = vim.lsp.protocol.CodeActionTriggerKind.Invoked,
  }

  vim.lsp.buf_request_all(bufnr, "textDocument/codeAction", params, function(results)
    local entries = {}
    local pkg = resolve_package(bufnr)

    for client_id, resp in pairs(results or {}) do
      if resp.result then
        local client = vim.lsp.get_client_by_id(client_id)
        local name = client and client.name or tostring(client_id)
        for _, action in ipairs(resp.result) do
          table.insert(entries, {
            action = action,
            client_id = client_id,
            client_name = name,
            package_name = pkg,
          })
        end
      end
    end

    -- Sort: preferred kinds first
    local kind_order = {}
    for i, k in ipairs(M._config.preferred_kinds) do
      kind_order[k] = i
    end

    table.sort(entries, function(a, b)
      local oa = kind_order[a.action.kind] or 999
      local ob = kind_order[b.action.kind] or 999
      if oa ~= ob then return oa < ob end
      return (a.action.title or "") < (b.action.title or "")
    end)

    callback(entries)
  end)
end

--- Filter entries by kind prefix
---@param entries CodeActionEntry[]
---@param kind_prefix string
---@return CodeActionEntry[]
function M.filter_by_kind(entries, kind_prefix)
  local filtered = {}
  for _, e in ipairs(entries) do
    if e.action.kind and vim.startswith(e.action.kind, kind_prefix) then
      table.insert(filtered, e)
    end
  end
  return filtered
end

--- Execute a code action entry
---@param entry CodeActionEntry
---@param bufnr number|nil
function M.execute(entry, bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local action = entry.action
  local client = entry.client_id and vim.lsp.get_client_by_id(entry.client_id) or nil

  -- Resolve if needed
  if not action.edit and not action.command then
    if not client then
      vim.notify("No client available to resolve code action", vim.log.levels.WARN)
      return
    end

    if not client.supports_method("codeAction/resolve") then
      vim.notify("Selected client does not support codeAction/resolve", vim.log.levels.WARN)
      return
    end

    client.request("codeAction/resolve", action, function(err, resolved)
      if err then
        vim.notify("Code action resolve failed: " .. tostring(err.message), vim.log.levels.ERROR)
        return
      end
      M._apply_action(resolved, bufnr, entry.client_id)
      M._record_history(entry)
    end, bufnr)
    return
  end

  M._apply_action(action, bufnr, entry.client_id)
  M._record_history(entry)
end

--- Apply workspace edit and/or command
---@param action lsp.CodeAction
---@param bufnr number
---@param client_id integer|nil
function M._apply_action(action, bufnr, client_id)
  local client = client_id and vim.lsp.get_client_by_id(client_id) or nil

  if action.edit then
    vim.lsp.util.apply_workspace_edit(action.edit, client and client.offset_encoding or "utf-8")
  end

  if action.command then
    local cmd = type(action.command) == "table" and action.command or action
    if not client then
      local clients = vim.lsp.get_clients({ bufnr = bufnr, method = "workspace/executeCommand" })
      client = clients[1]
    end

    if client then
      client.request("workspace/executeCommand", cmd, nil, bufnr)
    end
  end
end

--- Record to history ring
---@param entry CodeActionEntry
function M._record_history(entry)
  table.insert(M._history, 1, {
    title = entry.action.title,
    kind = entry.action.kind,
    client = entry.client_name,
    package = entry.package_name,
    time = os.time(),
  })
  while #M._history > M._config.max_history do
    table.remove(M._history)
  end
end

--- Interactive picker via vim.ui.select
---@param opts? { kind?: string }
function M.pick(opts)
  opts = opts or {}
  local bufnr = vim.api.nvim_get_current_buf()

  M.gather(bufnr, function(entries)
    if opts.kind then
      entries = M.filter_by_kind(entries, opts.kind)
    end

    if #entries == 0 then
      vim.notify("No code actions available", vim.log.levels.INFO)
      return
    end

    local items = {}
    for _, e in ipairs(entries) do
      local label = string.format("[%s] %s", e.action.kind or "action", e.action.title)
      if e.client_name then
        label = label .. "  (" .. e.client_name .. ")"
      end
      table.insert(items, label)
    end

    vim.ui.select(items, { prompt = "Code Actions:" }, function(_, idx)
      if idx then
        M.execute(entries[idx], bufnr)
      end
    end)
  end)
end

--- Telescope picker
---@param opts? { kind?: string }
function M.telescope(opts)
  opts = opts or {}
  local ok, _ = pcall(require, "telescope")
  if not ok then
    vim.notify("Telescope not available, falling back to vim.ui.select", vim.log.levels.WARN)
    return M.pick(opts)
  end

  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  local bufnr = vim.api.nvim_get_current_buf()

  M.gather(bufnr, function(entries)
    if opts.kind then
      entries = M.filter_by_kind(entries, opts.kind)
    end

    if #entries == 0 then
      vim.notify("No code actions available", vim.log.levels.INFO)
      return
    end

    pickers.new({}, {
      prompt_title = "Code Actions",
      finder = finders.new_table({
        results = entries,
        entry_maker = function(e)
          local display = string.format("[%s] %s  (%s | %s)",
            e.action.kind or "action",
            e.action.title,
            e.client_name,
            e.package_name or "")
          return {
            value = e,
            display = display,
            ordinal = display,
          }
        end,
      }),
      sorter = conf.generic_sorter({}),
      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          local selection = action_state.get_selected_entry()
          actions.close(prompt_bufnr)
          if selection then
            M.execute(selection.value, bufnr)
          end
        end)
        return true
      end,
    }):find()
  end)
end

--- Show action history
function M.history()
  if #M._history == 0 then
    vim.notify("No code action history", vim.log.levels.INFO)
    return
  end

  local lines = {}
  for _, h in ipairs(M._history) do
    table.insert(lines, string.format("[%s] %s (%s) — %s",
      h.kind or "?",
      h.title,
      h.client,
      os.date("%H:%M:%S", h.time)))
  end

  vim.ui.select(lines, { prompt = "Code Action History:" }, function() end)
end

--- Setup keymaps and commands
function M.setup()
  if commands_registered then
    return
  end

  vim.api.nvim_create_user_command("CodeAction", function(cmd)
    local kind = cmd.args ~= "" and cmd.args or nil
    M.pick({ kind = kind })
  end, { nargs = "?", desc = "Smart code action picker" })

  vim.api.nvim_create_user_command("CodeActionTelescope", function(cmd)
    local kind = cmd.args ~= "" and cmd.args or nil
    M.telescope({ kind = kind })
  end, { nargs = "?", desc = "Code actions via Telescope" })

  vim.api.nvim_create_user_command("CodeActionHistory", function()
    M.history()
  end, { desc = "Show code action history" })

  commands_registered = true
end

return M
