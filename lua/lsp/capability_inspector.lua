local M = {}

local config = {
  border = "rounded",
  width_ratio = 0.7,
  height_ratio = 0.6,
}

local commands_registered = false

local function format_capabilities(client)
  local lines = {}
  table.insert(lines, "── " .. client.name .. " (id: " .. client.id .. ") ──")
  table.insert(lines, "")

  local caps = client.server_capabilities or {}
  local keys = vim.tbl_keys(caps)
  table.sort(keys)

  for _, key in ipairs(keys) do
    local val = caps[key]
    local vtype = type(val)
    if vtype == "boolean" then
      local icon = val and "✓" or "✗"
      table.insert(lines, string.format("  %s %s", icon, key))
    elseif vtype == "table" then
      table.insert(lines, string.format("  ✓ %s = {…}", key))
    else
      table.insert(lines, string.format("  • %s = %s", key, tostring(val)))
    end
  end

  table.insert(lines, "")
  return lines
end

function M.show(opts)
  opts = opts or {}
  local bufnr = opts.bufnr or vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = bufnr })

  if #clients == 0 then
    vim.notify("No LSP clients attached to this buffer", vim.log.levels.INFO)
    return
  end

  local lines = { "LSP Capability Inspector", string.rep("═", 40), "" }

  for _, client in ipairs(clients) do
    vim.list_extend(lines, format_capabilities(client))
  end

  local float_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(float_buf, 0, -1, false, lines)
  vim.api.nvim_set_option_value("modifiable", false, { buf = float_buf })
  vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = float_buf })
  vim.api.nvim_set_option_value("filetype", "markdown", { buf = float_buf })

  local total_w = vim.o.columns
  local total_h = vim.o.lines
  local width = math.floor(total_w * config.width_ratio)
  local height = math.min(#lines + 2, math.floor(total_h * config.height_ratio))

  local win = vim.api.nvim_open_win(float_buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((total_h - height) / 2),
    col = math.floor((total_w - width) / 2),
    style = "minimal",
    border = config.border,
    title = " Capabilities ",
    title_pos = "center",
  })

  vim.keymap.set("n", "q", function()
    vim.api.nvim_win_close(win, true)
  end, { buffer = float_buf, nowait = true, silent = true })
end

function M.list(opts)
  opts = opts or {}
  local bufnr = opts.bufnr or vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  local result = {}
  for _, client in ipairs(clients) do
    result[client.name] = client.server_capabilities or {}
  end
  return result
end

function M.supports(method, opts)
  opts = opts or {}
  local bufnr = opts.bufnr or vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = bufnr, method = method })
  return #clients > 0
end

function M.setup(opts)
  config = vim.tbl_deep_extend("force", config, opts or {})

  if commands_registered then
    return
  end

  vim.api.nvim_create_user_command("LspCapabilities", function()
    M.show()
  end, { desc = "Inspect capabilities for attached LSP clients" })

  commands_registered = true
end

return M
