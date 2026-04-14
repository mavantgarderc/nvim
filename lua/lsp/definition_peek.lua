local M = {}

local peek_buf = nil
local peek_win = nil

local defaults = {
  width_ratio = 0.6,
  height_ratio = 0.4,
  border = "rounded",
  focus_on_open = false,
}

local config = vim.deepcopy(defaults)
local commands_registered = false

local function close_peek()
  if peek_win and vim.api.nvim_win_is_valid(peek_win) then
    vim.api.nvim_win_close(peek_win, true)
  end
  peek_win = nil
  peek_buf = nil
end

local function open_float(uri, range, title)
  close_peek()

  local bufnr = vim.uri_to_bufnr(uri)
  vim.fn.bufload(bufnr)

  local total_w = vim.o.columns
  local total_h = vim.o.lines
  local width = math.floor(total_w * config.width_ratio)
  local height = math.floor(total_h * config.height_ratio)
  local row = math.floor((total_h - height) / 2)
  local col = math.floor((total_w - width) / 2)

  peek_buf = bufnr
  peek_win = vim.api.nvim_open_win(bufnr, config.focus_on_open, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = config.border,
    title = title or " Definition ",
    title_pos = "center",
  })

  local target_line = range.start.line
  vim.api.nvim_win_set_cursor(peek_win, { target_line + 1, range.start.character })
  vim.api.nvim_set_option_value("cursorline", true, { win = peek_win })
  vim.api.nvim_set_option_value("number", true, { win = peek_win })

  -- close on leave
  vim.api.nvim_create_autocmd("BufLeave", {
    buffer = vim.api.nvim_get_current_buf(),
    once = true,
    callback = close_peek,
  })

  -- q to close inside peek
  vim.keymap.set("n", "q", close_peek, { buffer = bufnr, nowait = true, silent = true })
end

function M.open_location(uri, range, opts)
  if not uri or not range then
    return
  end

  open_float(uri, range, opts and opts.title or nil)
end

function M.peek()
  local params = vim.lsp.util.make_position_params()
  vim.lsp.buf_request(0, "textDocument/definition", params, function(err, result, _)
    if err then
      vim.notify("Peek: " .. tostring(err.message), vim.log.levels.ERROR)
      return
    end
    if not result or vim.tbl_isempty(result) then
      vim.notify("No definition found", vim.log.levels.INFO)
      return
    end
    local target = vim.islist(result) and result[1] or result
    local uri = target.uri or target.targetUri
    local range = target.range or target.targetSelectionRange
    if uri and range then
      open_float(uri, range)
    end
  end)
end

function M.close()
  close_peek()
end

function M.jump_into()
  if peek_win and vim.api.nvim_win_is_valid(peek_win) then
    vim.api.nvim_set_current_win(peek_win)
  end
end

function M.setup(opts)
  config = vim.tbl_deep_extend("force", defaults, opts or {})

  if commands_registered then
    return
  end

  vim.api.nvim_create_user_command("LspPeekDefinition", function()
    M.peek()
  end, { desc = "Peek definition in a floating window" })

  vim.api.nvim_create_user_command("LspPeekClose", function()
    M.close()
  end, { desc = "Close the definition peek window" })

  commands_registered = true
end

return M
