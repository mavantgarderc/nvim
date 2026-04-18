-- hover.lua
local M = {}

--- @type table<integer, { lines: string[], clients: string[], ts: number }>
M._cache = {}

--- @type table<integer, integer>
M._pin_bufs = {}

M.config = {
  border = "rounded",
  max_width = 80,
  max_height = 30,
  pin_timeout_ms = 0,
  merge_clients = true,
}

local setup_done = false

--- Normalize hover contents to markdown lines (handles 0.9 and 0.10+)
--- @param contents any
--- @return string[]
local function contents_to_lines(contents)
  if type(contents) == "string" then
    return vim.split(contents, "\n", { trimempty = true })
  end
  if type(contents) == "table" then
    if contents.kind and contents.value then
      return vim.split(contents.value, "\n", { trimempty = true })
    end
    -- MarkedString[] fallback
    if vim.islist(contents) then
      local lines = {}
      for _, item in ipairs(contents) do
        vim.list_extend(lines, contents_to_lines(item))
      end
      return lines
    end
    -- { language, value } MarkedString
    if contents.language and contents.value then
      local out = { "
```" .. contents.language }
vim.list_extend(out, vim.split(contents.value, "\n", { trimempty = true }))
table.insert(out, "
```")
      return out
    end
  end
  return {}
end

--- @param bufnr integer
--- @param callback fun(lines: string[], clients: string[])
function M._gather_hover(bufnr, callback)
  local clients = vim.lsp.get_clients({ bufnr = bufnr, method = "textDocument/hover" })
  if #clients == 0 then
    callback({}, {})
    return
  end

  local results = {}
  local client_names = {}
  local pending = #clients

  for _, client in ipairs(clients) do
    local params = vim.lsp.util.make_position_params(0, client.offset_encoding)
    client.request("textDocument/hover", params, function(err, result)
      if not err and result and result.contents then
        local text = contents_to_lines(result.contents)
        if #text > 0 then
          table.insert(results, { name = client.name, lines = text })
          table.insert(client_names, client.name)
        end
      end
      pending = pending - 1
      if pending > 0 then
        return
      end

      if #results == 0 then
        callback({}, {})
        return
      end

      if not M.config.merge_clients then
        callback(vim.deepcopy(results[1].lines), { results[1].name })
        return
      end

      local merged = {}
      for i, r in ipairs(results) do
        if i > 1 then
          table.insert(merged, "---")
          table.insert(merged, "")
        end
        if #results > 1 then
          table.insert(merged, "**[" .. r.name .. "]**")
          table.insert(merged, "")
        end
        vim.list_extend(merged, r.lines)
      end
      callback(merged, client_names)
    end, bufnr)
  end
end

--- @param opts? { pin?: boolean }
function M.hover(opts)
  opts = opts or {}
  local bufnr = vim.api.nvim_get_current_buf()

  M._gather_hover(bufnr, function(lines, clients)
    if #lines == 0 then
      vim.notify("No hover info", vim.log.levels.INFO)
      return
    end

    M._cache[bufnr] = { lines = lines, clients = clients, ts = vim.uv.now() }

    local float_buf, win = vim.lsp.util.open_floating_preview(lines, "markdown", {
      border = M.config.border,
      max_width = M.config.max_width,
      max_height = M.config.max_height,
      focus_id = "lsp_hover",
    })

    if opts.pin and float_buf then
      M._pin_bufs[bufnr] = float_buf
      if win and vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_set_config(win, { focusable = true })
      end
      if M.config.pin_timeout_ms > 0 then
        vim.defer_fn(function()
          M.unpin(bufnr)
        end, M.config.pin_timeout_ms)
      end
    end
  end)
end

function M.pin()
  M.hover({ pin = true })
end

--- @param bufnr? integer
function M.unpin(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local fb = M._pin_bufs[bufnr]
  if fb and vim.api.nvim_buf_is_valid(fb) then
    for _, w in ipairs(vim.fn.win_findbuf(fb)) do
      if vim.api.nvim_win_is_valid(w) then
        vim.api.nvim_win_close(w, true)
      end
    end
  end
  M._pin_bufs[bufnr] = nil
end

--- @param bufnr? integer
function M.get_cached(bufnr)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  return M._cache[bufnr]
end

--- @param bufnr? integer
function M.clear_cache(bufnr)
  if bufnr then
    M._cache[bufnr] = nil
  else
    M._cache = {}
  end
end

function M.setup(opts)
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})

  if setup_done then
    return
  end
  setup_done = true

  vim.api.nvim_create_user_command("LspHover", function()
    M.hover()
  end, { desc = "LSP: Enhanced hover" })

  vim.api.nvim_create_user_command("LspHoverPin", function()
    M.pin()
  end, { desc = "LSP: Pin hover window" })

  vim.api.nvim_create_user_command("LspHoverUnpin", function()
    M.unpin()
  end, { desc = "LSP: Unpin hover window" })

  vim.api.nvim_create_augroup("LspHover", { clear = true })
  vim.api.nvim_create_autocmd("BufDelete", {
    group = "LspHover",
    callback = function(ev)
      M._cache[ev.buf] = nil
      M._pin_bufs[ev.buf] = nil
    end,
  })
end

return M
