-- lua/Raphael/picker.lua
-- Raphael picker: palette floating window (centered full width), inline fuzzy search,
-- collapsible categories, bookmarks, preview (debounced), ordered palette blocks with real colors.
-- Compatible with Neovim 0.11.x

local themes = require("Raphael.themes")
local M = {}

-- windows / buffers
local picker_buf, picker_win
local palette_buf, palette_win
local search_buf, search_win

-- stored picker geometry
local picker_w, picker_h, picker_row, picker_col

-- core refs
local core_ref, state_ref
local previewed
local collapsed = {}
local bookmarks = {}
local search_query = ""

-- icons / glyphs
local ICON_BOOKMARK   = ""
local ICON_CURRENT_ON = ""
local ICON_CURRENT_OFF= ""
local ICON_GROUP_EXP  = ""
local ICON_GROUP_COL  = ""
local BLOCK_CHAR      = "▇"
local ICON_SEARCH     = ""

-- palette hl groups in order
local PALETTE_HL = { "Normal", "Comment", "String", "Identifier", "Function", "Type" }

-- cache of created palette highlight group names
local palette_hl_cache = {}

-- small helpers
local function trim(s) return (s or ""):gsub("^%s+", ""):gsub("%s+$", "") end
local function table_keys(t)
  local out = {}
  for k,_ in pairs(t) do table.insert(out, k) end
  return out
end

-- parse theme name from a display line:
-- returns nil if header; otherwise returns last token-ish word (letters, digits, _ or -)
local function parse_line_theme(line)
  if not line or line == "" then return nil end
  -- header lines end with "(N)" per render
  if line:match("%(%d+%)%s*$") then return nil end
  local theme = line:match("([%w_%-]+)%s*$")
  if theme and theme ~= "" then return theme end
  -- fallback: take last non-space token and strip non-word chars
  local last
  for token in line:gmatch("%S+") do last = token end
  if last then
    last = last:gsub("^[^%w_%-]+", ""):gsub("[^%w_%-]+$", "")
    if last ~= "" then return last end
  end
  return nil
end

-- debounce utility (vim.defer_fn)
local function debounce(ms, fn)
  local timer = nil
  return function(...)
    local args = { ... }
    if timer then pcall(vim.loop.timer_stop, timer); pcall(vim.loop.close, timer); timer = nil end
    timer = vim.defer_fn(function() pcall(fn, unpack(args)); timer = nil end, ms)
  end
end

-- safely get highlight table for a named highlight group (rgb). Try both APIs.
local function get_hl_rgb(name)
  -- prefer nvim_get_hl_by_name (returns ints when rgb=true)
  local ok, hl = pcall(vim.api.nvim_get_hl_by_name, name, true)
  if ok and type(hl) == "table" and (hl.bg or hl.fg) then return hl end
  -- fallback: nvim_get_hl (newer signature)
  ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = name })
  if ok and type(hl) == "table" and (hl.bg or hl.fg or hl.foreground) then return hl end
  return nil
end

-- ensure a highlight group for palette block exists (use integer color values)
local function ensure_palette_hl(idx, color_int)
  if not color_int then return nil end
  local key = ("RaphaelPalette_%d_%x"):format(idx, color_int)
  if palette_hl_cache[key] then return key end
  -- nvim_set_hl expects integer for rgb colors
  pcall(vim.api.nvim_set_hl, 0, key, { bg = color_int })
  palette_hl_cache[key] = true
  return key
end

-- update palette floating window (full-width of picker, centered squares)
function M.update_palette(theme)
  -- close palette if no theme or not available
  if not theme or not themes.is_available(theme) then
    if palette_win and vim.api.nvim_win_is_valid(palette_win) then pcall(vim.api.nvim_win_close, palette_win, true) end
    palette_win, palette_buf = nil, nil
    return
  end

  -- ensure we have picker's geometry
  if not picker_win or not vim.api.nvim_win_is_valid(picker_win) or not picker_w then return end

  -- create buffer if needed
  if not palette_buf or not vim.api.nvim_buf_is_valid(palette_buf) then
    palette_buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(palette_buf, "buftype", "nofile")
    vim.api.nvim_buf_set_option(palette_buf, "bufhidden", "wipe")
    vim.api.nvim_buf_set_option(palette_buf, "modifiable", false)
  end

  -- build blocks string and center it by padding spaces
  local blocks = {}
  for i = 1, #PALETTE_HL do blocks[i] = BLOCK_CHAR end
  local blocks_str = table.concat(blocks, " ")
  local display_w = vim.fn.strdisplaywidth(blocks_str)
  local pad = 0
  if picker_w and picker_w > display_w then pad = math.floor((picker_w - display_w) / 2) end
  local line = string.rep(" ", pad) .. blocks_str

  pcall(vim.api.nvim_buf_set_option, palette_buf, "modifiable", true)
  pcall(vim.api.nvim_buf_set_lines, palette_buf, 0, -1, false, { line })
  pcall(vim.api.nvim_buf_set_option, palette_buf, "modifiable", false)

  -- clear previous ns
  pcall(vim.api.nvim_buf_clear_namespace, palette_buf, 0, 0, -1)

  local bufline = (vim.api.nvim_buf_get_lines(palette_buf, 0, 1, false) or { "" })[1] or ""

  -- add highlights for each block using RGB integer values
  for i, hl_name in ipairs(PALETTE_HL) do
    local hl = get_hl_rgb(hl_name)
    if hl then
      local color_int = hl.bg or hl.fg or hl.foreground or hl.foreground -- prefer bg
      if color_int then
        local gname = ensure_palette_hl(i, color_int)
        -- find nth occurrence byte position of BLOCK_CHAR
        local start_pos = 1
        local found_pos = nil
        local count = 0
        while true do
          local s, e = string.find(bufline, BLOCK_CHAR, start_pos, true)
          if not s then break end
          count = count + 1
          if count == i then found_pos = s - 1 break end
          start_pos = e + 1
        end
        if found_pos then
          pcall(vim.api.nvim_buf_add_highlight, palette_buf, 0, gname, 0, found_pos, found_pos + 1)
        end
      end
    end
  end

  -- open or reposition floating window (full width of picker)
  local pal_row = math.max(picker_row - 1, 0)
  local pal_col = picker_col
  local pal_width = picker_w

  if palette_win and vim.api.nvim_win_is_valid(palette_win) then
    pcall(vim.api.nvim_win_set_buf, palette_win, palette_buf)
    pcall(vim.api.nvim_win_set_config, palette_win, {
      relative = "editor", width = pal_width, height = 1, row = pal_row, col = pal_col, style = "minimal", border = "rounded",
    })
  else
    palette_win = vim.api.nvim_open_win(palette_buf, false, {
      relative = "editor", width = pal_width, height = 1, row = pal_row, col = pal_col,
      style = "minimal", border = "rounded", zindex = 50,
    })
  end
end

-- render picker list
local function render()
  if not picker_buf or not vim.api.nvim_buf_is_valid(picker_buf) then return end
  local lines = {}

  -- preserve order by iterating pairs (your theme_map literal order is typically preserved)
  for group, items in pairs(themes.theme_map) do
    -- visible count for search (but full count used in summary when collapsed)
    local visible_count = 0
    for _, t in ipairs(items) do
      if search_query == "" or (t:lower():find(search_query:lower(), 1, true)) then visible_count = visible_count + 1 end
    end

    local header_icon = collapsed[group] and ICON_GROUP_COL or ICON_GROUP_EXP
    local summary = collapsed[group] and string.format("(%d themes hidden)", #items) or string.format("(%d)", #items)
    table.insert(lines, string.format("%s %s %s", header_icon, group, summary))

    if not collapsed[group] then
      for _, t in ipairs(items) do
        if search_query == "" or (t:lower():find(search_query:lower(), 1, true)) then
          local b = bookmarks[t] and ICON_BOOKMARK or " "
          local s = (state_ref and state_ref.current == t) and ICON_CURRENT_ON or ICON_CURRENT_OFF
          table.insert(lines, string.format("  %s %s %s", b, s, t))
        end
      end
    end
  end

  pcall(vim.api.nvim_buf_set_option, picker_buf, "modifiable", true)
  pcall(vim.api.nvim_buf_set_lines, picker_buf, 0, -1, false, lines)
  pcall(vim.api.nvim_buf_set_option, picker_buf, "modifiable", false)
end

-- close picker + associated windows
local function close_picker(revert)
  if revert and state_ref and state_ref.previous and themes.is_available(state_ref.previous) then pcall(vim.cmd.colorscheme, state_ref.previous) end
  if picker_win and vim.api.nvim_win_is_valid(picker_win) then pcall(vim.api.nvim_win_close, picker_win, true) end
  if palette_win and vim.api.nvim_win_is_valid(palette_win) then pcall(vim.api.nvim_win_close, palette_win, true) end
  if search_win and vim.api.nvim_win_is_valid(search_win) then pcall(vim.api.nvim_win_close, search_win, true) end
  picker_buf, picker_win, palette_buf, palette_win, search_buf, search_win = nil, nil, nil, nil, nil, nil
  search_query = ""
  previewed = nil
end

-- ensure picker buffer exists
local function ensure_picker_buf()
  if picker_buf and vim.api.nvim_buf_is_valid(picker_buf) then return end
  picker_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(picker_buf, "bufhidden", "wipe")
  vim.api.nvim_buf_set_option(picker_buf, "buftype", "nofile")
  vim.api.nvim_buf_set_option(picker_buf, "filetype", "raphael_picker")
end

-- preview function (debounced)
local function do_preview(theme)
  if not theme or not themes.is_available(theme) then return end
  if previewed == theme then return end
  previewed = theme
  pcall(vim.cmd.colorscheme, theme)
  -- save last suggested palette
  if core_ref and core_ref.state then core_ref.state.last_palette = theme; if core_ref.save_state then pcall(core_ref.save_state) end end
  pcall(M.update_palette, theme)
end
local preview = debounce(100, do_preview)

-- open inline search bar at bottom of picker
local function open_search()
  if not picker_win or not vim.api.nvim_win_is_valid(picker_win) then return end
  if search_win and vim.api.nvim_win_is_valid(search_win) then
    -- already open: focus
    pcall(vim.api.nvim_set_current_win, search_win)
    return
  end

  -- create prompt buffer & window aligned to picker
  search_buf = vim.api.nvim_create_buf(false, true)
  local s_row = picker_row + picker_h - 1 -- bottom row inside picker
  search_win = vim.api.nvim_open_win(search_buf, true, {
    relative = "editor",
    width = picker_w,
    height = 1,
    row = s_row,
    col = picker_col,
    style = "minimal",
    border = "rounded",
  })

  pcall(vim.api.nvim_buf_set_option, search_buf, "buftype", "prompt")
  vim.fn.prompt_setprompt(search_buf, ICON_SEARCH .. " ")
  pcall(vim.api.nvim_set_current_win, search_win)
  vim.cmd("startinsert")

  vim.api.nvim_create_autocmd({ "TextChangedI", "TextChanged" }, {
    buffer = search_buf,
    callback = function()
      local lines = vim.api.nvim_buf_get_lines(search_buf, 0, -1, false)
      local q = table.concat(lines, "\n"):gsub("^" .. ICON_SEARCH .. " ", "")
      search_query = trim(q)
      -- render results and keep them persistent after closing search
      render()
    end,
  })

  -- Esc: close search but keep filtered results
  vim.keymap.set("i", "<Esc>", function()
    if search_win and vim.api.nvim_win_is_valid(search_win) then pcall(vim.api.nvim_win_close, search_win, true) end
    search_buf, search_win = nil, nil
    vim.cmd("stopinsert")
    if picker_win and vim.api.nvim_win_is_valid(picker_win) then pcall(vim.api.nvim_set_current_win, picker_win) end
  end, { buffer = search_buf })

  -- CR: close search and keep results (cursor remains in picker)
  vim.keymap.set("i", "<CR>", function()
    if search_win and vim.api.nvim_win_is_valid(search_win) then pcall(vim.api.nvim_win_close, search_win, true) end
    search_buf, search_win = nil, nil
    vim.cmd("stopinsert")
    if picker_win and vim.api.nvim_win_is_valid(picker_win) then pcall(vim.api.nvim_set_current_win, picker_win) end
  end, { buffer = search_buf })

  -- Ctrl-L: reset search
  vim.keymap.set("i", "<C-l>", function()
    search_query = ""
    render()
  end, { buffer = search_buf })
end

-- open picker
function M.open(core)
  core_ref = core
  state_ref = core.state

  -- load persisted bookmarks/collapsed
  bookmarks = {}
  for _, b in ipairs(state_ref.bookmarks or {}) do bookmarks[b] = true end
  collapsed = type(state_ref.collapsed) == "table" and vim.deepcopy(state_ref.collapsed) or {}

  ensure_picker_buf()

  -- compute geometry and store for subwindows
  picker_h = math.max(6, math.floor(vim.o.lines * 0.6))
  picker_w = math.floor(vim.o.columns * 0.5)
  picker_row = math.floor((vim.o.lines - picker_h) / 2)
  picker_col = math.floor((vim.o.columns - picker_w) / 2)

  picker_win = vim.api.nvim_open_win(picker_buf, true, {
    relative = "editor",
    width = picker_w,
    height = picker_h,
    row = picker_row,
    col = picker_col,
    style = "minimal",
    border = "rounded",
    title = "Raphael",
  })

  -- remember previous theme to revert on cancel
  state_ref.previous = vim.g.colors_name

  -- keymaps
  vim.keymap.set("n", "q", function() close_picker(true) end, { buffer = picker_buf })
  vim.keymap.set("n", "<Esc>", function() close_picker(true) end, { buffer = picker_buf })

  -- header <CR> toggles collapse; theme <CR> applies
  vim.keymap.set("n", "<CR>", function()
    local line = vim.api.nvim_get_current_line()
    local hdr = line:match("^%s*[]%s*(.+)%s*%(")
    if hdr then
      collapsed[hdr] = not collapsed[hdr]
      state_ref.collapsed = vim.deepcopy(collapsed)
      if core_ref and core_ref.save_state then pcall(core_ref.save_state) end
      render()
      return
    end

    local theme = parse_line_theme(line)
    if theme and themes.is_available(theme) then
      if core_ref and core_ref.apply then pcall(core_ref.apply, theme) end
      state_ref.current = theme
      if core_ref and core_ref.save_state then pcall(core_ref.save_state) end
      close_picker(false)
    else
      vim.notify("Raphael: no theme on this line", vim.log.levels.INFO)
    end
  end, { buffer = picker_buf })

  -- bookmark toggle (leader + b) in picker
  vim.keymap.set("n", core_ref.config.leader .. "b", function()
    local line = vim.api.nvim_get_current_line()
    local theme = parse_line_theme(line)
    if not theme then return end
    bookmarks[theme] = not bookmarks[theme]
    local arr = {}
    for t, _ in pairs(bookmarks) do table.insert(arr, t) end
    state_ref.bookmarks = arr
    if core_ref and core_ref.save_state then pcall(core_ref.save_state) end
    render()
    pcall(M.update_palette, state_ref.current)
  end, { buffer = picker_buf })

  -- preview on cursor move (debounced)
  vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
    buffer = picker_buf,
    callback = function()
      local raw = vim.api.nvim_get_current_line()
      local theme = parse_line_theme(raw)
      if theme then
        preview(theme)
        -- remember cursor
        state_ref.last_cursor = vim.api.nvim_win_get_cursor(picker_win)
        state_ref.last_palette = theme
        if core_ref and core_ref.save_state then pcall(core_ref.save_state) end
      end
    end,
  })

  -- search mapping
  vim.keymap.set("n", "/", function() open_search() end, { buffer = picker_buf })

  -- initial render and restore cursor/palette
  render()
  vim.schedule(function()
    if state_ref.last_cursor and type(state_ref.last_cursor) == "table" then
      pcall(vim.api.nvim_win_set_cursor, picker_win, state_ref.last_cursor)
    else
      local lines = vim.api.nvim_buf_get_lines(picker_buf, 0, -1, false)
      for i, l in ipairs(lines) do
        local theme = parse_line_theme(l)
        if theme and state_ref.current == theme then pcall(vim.api.nvim_win_set_cursor, picker_win, { i, 0 }); break end
      end
    end
    pcall(M.update_palette, state_ref.last_palette or state_ref.current)
  end)
end

return M
