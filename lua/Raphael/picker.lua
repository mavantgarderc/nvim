local themes = require("Raphael.themes")

local M = {}
local state_ref, core_ref, win, buf, previewed = nil, nil, nil, nil, nil
local collapsed = {}

-- Icons
local ICON_BOOKMARK = ""
local ICON_INSTALLED = ""
local ICON_MISSING = ""
local ICON_CURRENT = ""

-- Helpers
local function is_bookmarked(theme)
  return vim.tbl_contains(state_ref.bookmarks or {}, theme)
end

local function ensure_buf()
  if buf and vim.api.nvim_buf_is_valid(buf) then return end
  buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
  vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
  vim.api.nvim_buf_set_option(buf, "filetype", "raphael_picker")
end

local function ordered_groups()
  local out = {}
  for k, _ in pairs(themes.theme_map) do table.insert(out, k) end
  return out
end

local function render()
  ensure_buf()
  local lines = {}
  for _, group in ipairs(ordered_groups()) do
    local entries = themes.theme_map[group] or {}
    local sign = collapsed[group] and "▶" or "▼"
    table.insert(lines, string.format("%s %s", sign, group))
    if not collapsed[group] then
      for _, theme in ipairs(entries) do
        local installed = themes.is_available(theme)
        local icon = is_bookmarked(theme) and ICON_BOOKMARK or " "
        local dot = installed and ICON_INSTALLED or ICON_MISSING
        local current_marker = (theme == state_ref.current) and (" " .. ICON_CURRENT) or ""
        table.insert(lines, string.format("%s%s %s%s", icon, dot, theme, current_marker))
      end
    end
  end
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
end

local function parse_line_theme(line)
  -- Remove all leading icons & whitespace
  local theme = line:gsub("^[^%w]*", ""):gsub("%s*" .. ICON_CURRENT .. "$", "")
  return vim.trim(theme)
end

local function preview(theme)
  if not theme or not themes.is_available(theme) then return end
  if previewed == theme then return end
  previewed = theme
  local ok, err = pcall(vim.cmd.colorscheme, theme)
  if ok then
    vim.notify("Preview: " .. theme)
  else
    vim.notify("Preview failed: " .. tostring(err), vim.log.levels.WARN)
  end
end

local function revert_to_previous()
  if core_ref and core_ref.state and core_ref.state.previous then
    local prev = core_ref.state.previous
    if themes.is_available(prev) then
      pcall(vim.cmd.colorscheme, prev)
    elseif themes.is_available("kanagawa-paper-ink") then
      pcall(vim.cmd.colorscheme, "kanagawa-paper-ink")
    end
  end
end

local function close_picker(revert)
  if revert then revert_to_previous() end
  if win and vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_win_close(win, true)
  end
  win, buf, previewed = nil, nil, nil
end

-- Main picker function
function M.open(core)
  core_ref = core
  state_ref = core.state
  previewed = nil
  ensure_buf()

  local width = math.floor(vim.o.columns * 0.5)
  local height = math.floor(vim.o.lines * 0.6)
  win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    style = "minimal",
    border = "rounded",
    title = "Raphael",
  })

  core.state.previous = vim.g.colors_name
  render()

  -- Keymaps
  vim.keymap.set("n", "q", function() close_picker(true) end, { buffer = buf })
  vim.keymap.set("n", "<Esc>", function() close_picker(true) end, { buffer = buf })

  vim.keymap.set("n", "<CR>", function()
    local line = vim.api.nvim_get_current_line()
    local theme = parse_line_theme(line)
    if theme then
      vim.notify("Selected: " .. theme)
      if themes.is_available(theme) then
        core.apply(theme)
      else
        vim.notify("Theme not available: " .. theme, vim.log.levels.WARN)
      end
    end
    close_picker(false)
  end, { buffer = buf })

  vim.keymap.set("n", "<leader>tb", function()
    local line = vim.api.nvim_get_current_line()
    local theme = parse_line_theme(line)
    if not theme then return vim.notify("No theme here", vim.log.levels.INFO) end
    core.toggle_bookmark(theme)
    render()
  end, { buffer = buf })

  vim.keymap.set("n", "c", function()
    local line = vim.api.nvim_get_current_line()
    local hdr = line:match("^%s*[▶▼]%s*(.+)$")
    if hdr then collapsed[hdr] = not collapsed[hdr]; render() end
  end, { buffer = buf })

  -- Cursor preview
  vim.api.nvim_create_autocmd({"CursorMoved", "CursorMovedI"}, {
    buffer = buf,
    callback = function()
      local line = vim.api.nvim_get_current_line()
      local theme = parse_line_theme(line)
      if theme then preview(theme) end
    end,
  })

  -- Auto-select current theme
  vim.schedule(function()
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    for i, l in ipairs(lines) do
      local theme = parse_line_theme(l)
      if theme and theme == state_ref.current then
        pcall(vim.api.nvim_win_set_cursor, win, { i, 0 })
        break
      end
    end
  end)
end

return M
