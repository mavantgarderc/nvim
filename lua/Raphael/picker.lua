-- lua/Raphael/picker.lua
local themes = require("Raphael.themes")

local M = {}
local state_ref, core_ref, win, buf, previewed = nil, nil, nil, nil, nil
local collapsed = {}

-- Icons
local ICON_BOOKMARK = ""
local ICON_INSTALLED = ""
local ICON_MISSING = ""
local ICON_CURRENT = ""

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
  if not line or line == "" then return nil end
  if line:match("^%s*[▶▼]") then return nil end
  -- remove all leading non-alphanumeric characters (icons + spaces), then strip trailing current icon
  local theme = line:gsub("^[^%w]*", ""):gsub("%s*" .. ICON_CURRENT .. "$", "")
  return vim.trim(theme)
end

local function preview(theme)
  if not theme or not themes.is_available(theme) then return end
  if previewed == theme then return end
  previewed = theme
  local ok, err = pcall(vim.cmd.colorscheme, theme)
  if ok then
    vim.notify("Raphael preview: " .. theme)
  else
    vim.notify("Raphael: preview failed for " .. theme .. ": " .. tostring(err), vim.log.levels.WARN)
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

function M.open(core)
  core_ref = core
  state_ref = core.state
  previewed = nil
  ensure_buf()

  -- restore persisted collapsed state from core.state (if any)
  if core_ref and core_ref.state and type(core_ref.state.collapsed) == "table" then
    collapsed = vim.deepcopy(core_ref.state.collapsed)
  else
    collapsed = {} -- default: expanded
  end

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

  -- keymaps
  vim.keymap.set("n", "q", function() close_picker(true) end, { buffer = buf })
  vim.keymap.set("n", "<Esc>", function() close_picker(true) end, { buffer = buf })

  vim.keymap.set("n", "<CR>", function()
    local line = vim.api.nvim_get_current_line()
    local theme = parse_line_theme(line)
    if theme then
      vim.notify("Raphael selected: " .. theme)
      if themes.is_available(theme) then
        core.apply(theme)
      else
        vim.notify("Raphael: theme not available: " .. theme, vim.log.levels.WARN)
      end
    end
    close_picker(false)
  end, { buffer = buf })

  vim.keymap.set("n", "<leader>tb", function()
    local line = vim.api.nvim_get_current_line()
    local theme = parse_line_theme(line)
    if not theme then
      vim.notify("Raphael: no theme on this line to bookmark", vim.log.levels.INFO)
      return
    end
    core.toggle_bookmark(theme)
    render()
  end, { buffer = buf })

  -- collapse toggle on header with 'c' and persist to core.state
  vim.keymap.set("n", "c", function()
    local line = vim.api.nvim_get_current_line()
    local hdr = line:match("^%s*[▶▼]%s*(.+)$")
    if hdr then
      collapsed[hdr] = not collapsed[hdr]
      -- persist into core.state and save via core.save_state (if available)
      if core_ref and core_ref.state then
        core_ref.state.collapsed = vim.deepcopy(collapsed)
        if core_ref.save_state then core_ref.save_state() end
      end
      render()
    end
  end, { buffer = buf })

  -- live preview on cursor move
  vim.api.nvim_create_autocmd({"CursorMoved", "CursorMovedI"}, {
    buffer = buf,
    callback = function()
      local line = vim.api.nvim_get_current_line()
      local theme = parse_line_theme(line)
      if theme then preview(theme) end
    end,
  })

  -- focus current theme on open
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
