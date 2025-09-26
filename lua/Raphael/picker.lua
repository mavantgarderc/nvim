local themes = require("Raphael.themes")
local util   = require("Raphael.util")
local cache  = require("Raphael.cache")

local M = {}

local state
local win, buf
local preview_timer = nil
local last_preview = 0

local function close_picker()
  if win and vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_win_close(win, true)
  end
  win, buf = nil, nil
end

local function render()
  local lines = {}
  for group, entries in pairs(themes.theme_map) do
    table.insert(lines, "▶ " .. group)
    for _, theme in ipairs(entries) do
      local installed = themes.is_available(theme)
      local prefix = installed and "  • " or "  × "
      table.insert(lines, prefix .. theme)
    end
  end
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
end

local function preview(theme)
  local now = vim.loop.now()
  if now - last_preview < 300 then return end -- throttle 3/s
  last_preview = now
  state.previous = vim.g.colors_name
  local ok = pcall(vim.cmd.colorscheme, theme)
  if not ok then
    vim.notify("Raphael: failed to preview " .. theme, vim.log.levels.WARN)
  end
end

function M.open(core)
  state = core.state

  buf = vim.api.nvim_create_buf(false, true)
  local width = math.floor(vim.o.columns * 0.5)
  local height = math.floor(vim.o.lines * 0.6)
  win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    border = "rounded",
    title = "Raphael",
  })

  render()

  vim.keymap.set("n", "q", close_picker, { buffer = buf })
  vim.keymap.set("n", "<Esc>", close_picker, { buffer = buf })
  vim.keymap.set("n", "<CR>", function()
    local line = vim.api.nvim_get_current_line()
    local theme = line:match("• (.+)") or line:match("× (.+)")
    if theme then
      core.apply(theme)
    end
    close_picker()
  end, { buffer = buf })

  vim.api.nvim_create_autocmd("CursorMoved", {
    buffer = buf,
    callback = function()
      local line = vim.api.nvim_get_current_line()
      local theme = line:match("• (.+)") or line:match("× (.+)")
      if theme then preview(theme) end
    end,
  })
end

return M
