-- lua/Raphael/picker.lua

local themes = require("Raphael.themes")

local M = {}

-- core state refs
local buf, win
local core_ref, state_ref
local previewed
local collapsed = {}
local bookmarks = {}
local search_win, search_buf
local search_query = ""

-- icons / glyphs (nerd-fonts)
local ICON_BOOKMARK = ""
local ICON_CURRENT  = ""
local ICON_NORMAL   = ""
local ICON_COLLAPSE = "▼"
local ICON_EXPAND   = "▶"

-- utils
local function trim(s) return (s or ""):gsub("^%s+", ""):gsub("%s+$", "") end

-- parse theme name from a displayed line
local function parse_line_theme(line)
  if not line or line == "" then return nil end
  if line:match("^%s*[▼▶]") then return nil end
  -- strip leading non (word, hyphen, underscore) chars, then strip trailing non-word chars
  local theme = line:gsub("^[^%w_%-]+", ""):gsub("[^%w_%-]+$", "")
  return trim(theme)
end

-- debounce helper using vim.defer_fn
local function debounce(ms, fn)
  local timer = nil
  return function(...)
    local args = { ... }
    if timer then pcall(vim.loop.timer_stop, timer); pcall(vim.loop.close, timer); timer = nil end
    timer = vim.defer_fn(function()
      pcall(fn, unpack(args))
      timer = nil
    end, ms)
  end
end

-- actual preview function (applies colorscheme)
local function do_preview(theme)
  if not theme or not themes.is_available(theme) then return end
  if previewed == theme then return end
  previewed = theme
  local ok, err = pcall(vim.cmd.colorscheme, theme)
  if ok then
    vim.notify("Raphael preview: " .. theme)
  else
    vim.notify("Raphael: preview failed for " .. tostring(theme) .. ": " .. tostring(err), vim.log.levels.WARN)
  end
end

-- debounced preview (100ms)
local preview = debounce(100, do_preview)

-- render function: builds visible lines using current search_query, collapsed, bookmarks
local function render()
  if not buf or not vim.api.nvim_buf_is_valid(buf) then return end
  local lines = {}

  -- preserve key order as much as Lua allows; user provided map order is used
  for group, items in pairs(themes.theme_map) do
    local header_icon = collapsed[group] and ICON_EXPAND or ICON_COLLAPSE
    table.insert(lines, string.format("%s %s", header_icon, group))

    if not collapsed[group] then
      for _, theme in ipairs(items) do
        -- filter by search query if present
        if search_query == "" or (theme:lower():find(search_query:lower(), 1, true)) then
          local mark = bookmarks[theme] and ICON_BOOKMARK or ICON_NORMAL
          local current = (state_ref and state_ref.current == theme) and (" " .. ICON_CURRENT) or ""
          table.insert(lines, string.format("  %s %s%s", mark, theme, current))
        end
      end
    end
  end

  vim.api.nvim_buf_set_option(buf, "modifiable", true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(buf, "modifiable", false)
end

-- close picker and any search window
local function close_picker(revert)
  if revert and state_ref and state_ref.previous and themes.is_available(state_ref.previous) then
    pcall(vim.cmd.colorscheme, state_ref.previous)
  end
  if win and vim.api.nvim_win_is_valid(win) then pcall(vim.api.nvim_win_close, win, true) end
  if search_win and vim.api.nvim_win_is_valid(search_win) then pcall(vim.api.nvim_win_close, search_win, true) end
  buf, win, search_win, search_buf = nil, nil, nil, nil
  search_query = ""
  previewed = nil
end

-- open tiny floating search window below the picker
local function open_search()
  if not win or not vim.api.nvim_win_is_valid(win) then return end
  -- safe read of win config values (row/col/width/height might be number or table)
  local cfg = vim.api.nvim_win_get_config(win)
  local win_width = cfg.width
  local win_height = cfg.height
  local win_row = (type(cfg.row) == "table" and cfg.row[false] or cfg.row) or 0
  local win_col = (type(cfg.col) == "table" and cfg.col[false] or cfg.col) or 0
  -- compute search window position: right below picker
  local s_row = win_row + (type(win_height) == "table" and win_height[false] or win_height)
  local s_col = win_col
  local s_width = win_width
  local s_height = 1

  -- create prompt buffer & window
  search_buf = vim.api.nvim_create_buf(false, true)
  search_win = vim.api.nvim_open_win(search_buf, true, {
    relative = "editor",
    width = s_width,
    height = s_height,
    row = s_row,
    col = s_col,
    style = "minimal",
    border = "rounded",
    title = "Raphael Search",
  })

  vim.api.nvim_buf_set_option(search_buf, "bufhidden", "wipe")
  -- use prompt buffer for good UX
  vim.api.nvim_buf_set_option(search_buf, "buftype", "prompt")
  vim.fn.prompt_setprompt(search_buf, "/ ")

  -- ensure we're in insert in the search window
  vim.api.nvim_set_current_win(search_win)
  vim.cmd("startinsert")

  -- live update on TextChangedI/TextChanged
  vim.api.nvim_create_autocmd({ "TextChangedI", "TextChanged" }, {
    buffer = search_buf,
    callback = function()
      local lines = vim.api.nvim_buf_get_lines(search_buf, 0, -1, false)
      local query = table.concat(lines, "\n")
      query = query:gsub("^/ ", "")
      search_query = trim(query)
      -- debug notify and render
      local count = 0
      for _, items in pairs(themes.theme_map) do
        for _, t in ipairs(items) do
          if search_query == "" or (t:lower():find(search_query:lower(), 1, true)) then count = count + 1 end
        end
      end
      vim.notify(("Raphael search: '%s' (%d matches)"):format(search_query, count))
      render()
    end,
  })

  -- close and reset on <Esc>
  vim.keymap.set("i", "<Esc>", function()
    -- close search and reset query
    search_query = ""
    if search_win and vim.api.nvim_win_is_valid(search_win) then pcall(vim.api.nvim_win_close, search_win, true) end
    search_win, search_buf = nil, nil
    vim.cmd("stopinsert")
    render()
    -- refocus picker window if valid
    if win and vim.api.nvim_win_is_valid(win) then pcall(vim.api.nvim_set_current_win, win) end
  end, { buffer = search_buf })

  -- close on <CR> (commit nothing, reset list)
  vim.keymap.set("i", "<CR>", function()
    search_query = ""
    if search_win and vim.api.nvim_win_is_valid(search_win) then pcall(vim.api.nvim_win_close, search_win, true) end
    search_win, search_buf = nil, nil
    vim.cmd("stopinsert")
    render()
    if win and vim.api.nvim_win_is_valid(win) then pcall(vim.api.nvim_set_current_win, win) end
  end, { buffer = search_buf })
end

-- ensure picker buffer exists and options set
local function ensure_buf()
  if buf and vim.api.nvim_buf_is_valid(buf) then return end
  buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
  vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
  vim.api.nvim_buf_set_option(buf, "filetype", "raphael_picker")
end

-- open picker
function M.open(core)
  core_ref = core
  state_ref = core.state
  bookmarks = {}
  for _, b in ipairs(state_ref.bookmarks or {}) do bookmarks[b] = true end
  collapsed = vim.tbl_isempty(state_ref.collapsed) and {} or (type(state_ref.collapsed) == "table" and vim.deepcopy(state_ref.collapsed) or {})

  ensure_buf()

  local width = math.floor(vim.o.columns * 0.5)
  local height = math.floor(vim.o.lines * 0.6)
  local row = math.floor((vim.o.lines - height) / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
    title = "Raphael",
  })

  -- remember previous theme for revert on cancel
  state_ref.previous = vim.g.colors_name

  -- keymaps
  vim.keymap.set("n", "q", function() close_picker(true) end, { buffer = buf })
  vim.keymap.set("n", "<Esc>", function() close_picker(true) end, { buffer = buf })

  -- collapse toggle
  vim.keymap.set("n", "c", function()
    local line = vim.api.nvim_get_current_line()
    local hdr = line:match("^%s*[▶▼]%s*(.+)$")
    if hdr then
      collapsed[hdr] = not collapsed[hdr]
      -- persist collapsed into core state and save if core exposes save_state
      if core_ref and core_ref.state then
        core_ref.state.collapsed = vim.deepcopy(collapsed)
        if core_ref.save_state then core_ref.save_state() end
      end
      render()
    end
  end, { buffer = buf })

  -- bookmark toggle (uses core.toggle_bookmark if available)
  vim.keymap.set("n", core_ref.config.leader .. "b", function()
    local line = vim.api.nvim_get_current_line()
    local theme = parse_line_theme(line)
    if not theme then return vim.notify("No theme here", vim.log.levels.INFO) end
    if core_ref.toggle_bookmark then
      core_ref.toggle_bookmark(theme)
      -- update local cache
      if bookmarks[theme] then bookmarks[theme] = nil else bookmarks[theme] = true end
      core_ref.state.bookmarks = vim.tbl_keys(bookmarks)
    else
      -- fallback local toggle
      if bookmarks[theme] then bookmarks[theme] = nil else bookmarks[theme] = true end
      core_ref.state.bookmarks = vim.tbl_keys(bookmarks)
    end
    render()
  end, { buffer = buf })

  -- apply on CR
  vim.keymap.set("n", "<CR>", function()
    local line = vim.api.nvim_get_current_line()
    local theme = parse_line_theme(line)
    if theme and themes.is_available(theme) then
      if core_ref and core_ref.apply then core_ref.apply(theme) end
      vim.notify("Raphael applied: " .. theme)
    else
      if theme then vim.notify("Raphael: theme not available: " .. theme, vim.log.levels.WARN) end
    end
    close_picker(false)
  end, { buffer = buf })

  -- preview on cursor move (debounced)
  vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
    buffer = buf,
    callback = function()
      local line = vim.api.nvim_get_current_line()
      local theme = parse_line_theme(line)
      if theme then preview(theme) end
    end,
  })

  -- open search with /
  vim.keymap.set("n", "/", function() open_search() end, { buffer = buf })

  -- render initial content and position to current theme
  render()
  vim.schedule(function()
    local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
    for i, l in ipairs(lines) do
      local theme = parse_line_theme(l)
      if theme and state_ref.current == theme then
        pcall(vim.api.nvim_win_set_cursor, win, { i, 0 })
        break
      end
    end
  end)
end

return M
