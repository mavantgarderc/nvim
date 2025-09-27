-- lua/Raphael/picker.lua
-- Raphael picker (fixed parser + preview + palette for Neovim 0.11+)

local themes = require("Raphael.themes")
local M = {}

-- core refs
local picker_buf, picker_win
local palette_buf, palette_win
local core_ref, state_ref
local previewed
local collapsed = {}
local bookmarks = {}
local search_win, search_buf
local search_query = ""

-- icons
local ICON_BOOKMARK   = ""
local ICON_CURRENT_ON = ""
local ICON_CURRENT_OFF= ""
local ICON_GROUP_EXP  = ""
local ICON_GROUP_COL  = ""
local BLOCK_CHAR      = "▇"

-- highlight groups for palette (ordered)
local PALETTE_HL = { "Normal", "Comment", "String", "Identifier", "Function", "Type" }

local function trim(s) return (s or ""):gsub("^%s+", ""):gsub("%s+$", "") end

-- robust parser: skip header lines and return last token-like word
local function parse_line_theme(line)
  if not line or line == "" then return nil end
  -- header lines have "(N)" at end (we render "Group (N)"), treat them as header
  if line:match("%(%d+%)%s*$") then return nil end
  -- try simple last-token match (letters, digits, underscore, hyphen)
  local theme = line:match("([%w_%-]+)%s*$")
  if theme and theme ~= "" then return theme end
  -- fallback: split on whitespace, take last token and strip non-word chars
  local last
  for token in line:gmatch("%S+") do last = token end
  if last then
    last = last:gsub("^[^%w_%-]+", ""):gsub("[^%w_%-]+$", "")
    if last ~= "" then return last end
  end
  return nil
end

-- simple debounce wrapper using vim.defer_fn
local function debounce(ms, fn)
  local timer = nil
  return function(...)
    local args = { ... }
    if timer then pcall(vim.loop.timer_stop, timer); pcall(vim.loop.close, timer); timer = nil end
    timer = vim.defer_fn(function() pcall(fn, unpack(args)); timer = nil end, ms)
  end
end

-- small helper: convert integer color to hex string
local function int_to_hex(n)
  if type(n) ~= "number" then return nil end
  return string.format("#%06x", n)
end

-- ensure palette highlight group
local palette_hl_cache = {}
local function ensure_palette_hl(idx, hex)
  if not hex then return nil end
  local name = ("RaphaelPalette%d_%s"):format(idx, hex:gsub("#",""))
  if palette_hl_cache[name] then return name end
  pcall(vim.api.nvim_set_hl, 0, name, { bg = hex })
  palette_hl_cache[name] = true
  return name
end

-- update (or create) palette floating window showing colored blocks for `theme`
function M.update_palette(theme)
  if not theme or not themes.is_available(theme) then
    if palette_win and vim.api.nvim_win_is_valid(palette_win) then pcall(vim.api.nvim_win_close, palette_win, true) end
    palette_win, palette_buf = nil, nil
    return
  end

  if not picker_win or not vim.api.nvim_win_is_valid(picker_win) then return end

  if not palette_buf or not vim.api.nvim_buf_is_valid(palette_buf) then
    palette_buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(palette_buf, "buftype", "nofile")
    vim.api.nvim_buf_set_option(palette_buf, "bufhidden", "wipe")
    vim.api.nvim_buf_set_option(palette_buf, "modifiable", false)
  end

  -- one line with BLOCK_CHARs separated by spaces
  local blocks = {}
  for i = 1, #PALETTE_HL do blocks[i] = BLOCK_CHAR end
  local palette_line = table.concat(blocks, " ")
  pcall(vim.api.nvim_buf_set_option, palette_buf, "modifiable", true)
  pcall(vim.api.nvim_buf_set_lines, palette_buf, 0, -1, false, { palette_line })
  pcall(vim.api.nvim_buf_set_option, palette_buf, "modifiable", false)

  -- clear previous highlights
  pcall(vim.api.nvim_buf_clear_namespace, palette_buf, 0, 0, -1)

  local bufline = (vim.api.nvim_buf_get_lines(palette_buf, 0, 1, false) or { "" })[1] or ""

  for i, hl_name in ipairs(PALETTE_HL) do
    local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = hl_name })
    if ok and hl then
      -- prefer bg then fg
      local hex = int_to_hex(hl.bg or hl.fg)
      if hex then
        local gname = ensure_palette_hl(i, hex)
        -- find i-th BLOCK_CHAR byte position
        local pos = nil
        local count = 0
        local byte_index = 1
        for _, code in utf8.codes(bufline) do
          local ch = utf8.char(code)
          if ch == BLOCK_CHAR then
            count = count + 1
            if count == i then pos = byte_index - 1; break end
          end
          byte_index = byte_index + 1
        end
        if pos then
          pcall(vim.api.nvim_buf_add_highlight, palette_buf, 0, gname, 0, pos, pos + 1)
        end
      end
    end
  end

  -- place palette window one row above the picker
  local cfg = vim.api.nvim_win_get_config(picker_win)
  local p_width = cfg.width
  local p_row = (type(cfg.row) == "table" and cfg.row[false] or cfg.row) or 0
  local p_col = (type(cfg.col) == "table" and cfg.col[false] or cfg.col) or 0
  local palette_row = p_row - 1
  if palette_row < 0 then palette_row = 0 end

  if palette_win and vim.api.nvim_win_is_valid(palette_win) then
    pcall(vim.api.nvim_win_set_buf, palette_win, palette_buf)
    pcall(vim.api.nvim_win_set_config, palette_win, {
      relative = "editor", width = p_width, height = 1, row = palette_row, col = p_col, style = "minimal", border = "rounded",
    })
  else
    palette_win = vim.api.nvim_open_win(palette_buf, false, {
      relative = "editor", width = p_width, height = 1, row = palette_row, col = p_col,
      style = "minimal", border = "rounded", zindex = 50,
    })
  end
end

-- render list (headers + themes)
local function render()
  if not picker_buf or not vim.api.nvim_buf_is_valid(picker_buf) then return end
  local lines = {}
  for group, items in pairs(themes.theme_map) do
    local visible_count = 0
    for _, t in ipairs(items) do
      if search_query == "" or (t:lower():find(search_query:lower(), 1, true)) then visible_count = visible_count + 1 end
    end
    local header_icon = collapsed[group] and ICON_GROUP_COL or ICON_GROUP_EXP
    table.insert(lines, string.format("%s %s (%d)", header_icon, group, visible_count))
    if not collapsed[group] then
      for _, theme in ipairs(items) do
        if search_query == "" or theme:lower():find(search_query:lower(), 1, true) then
          local b = bookmarks[theme] and ICON_BOOKMARK or " "
          local s = (state_ref and state_ref.current == theme) and ICON_CURRENT_ON or ICON_CURRENT_OFF
          table.insert(lines, string.format("  %s %s %s", b, s, theme))
        end
      end
    end
  end

  pcall(vim.api.nvim_buf_set_option, picker_buf, "modifiable", true)
  pcall(vim.api.nvim_buf_set_lines, picker_buf, 0, -1, false, lines)
  pcall(vim.api.nvim_buf_set_option, picker_buf, "modifiable", false)
end

-- close everything
local function close_picker(revert)
  if revert and state_ref and state_ref.previous and themes.is_available(state_ref.previous) then pcall(vim.cmd.colorscheme, state_ref.previous) end
  if picker_win and vim.api.nvim_win_is_valid(picker_win) then pcall(vim.api.nvim_win_close, picker_win, true) end
  if palette_win and vim.api.nvim_win_is_valid(palette_win) then pcall(vim.api.nvim_win_close, palette_win, true) end
  if search_win and vim.api.nvim_win_is_valid(search_win) then pcall(vim.api.nvim_win_close, search_win, true) end
  picker_buf, picker_win, palette_buf, palette_win, search_buf, search_win = nil, nil, nil, nil, nil, nil
  search_query = ""
  previewed = nil
end

-- ensure picker's buffer
local function ensure_picker_buf()
  if picker_buf and vim.api.nvim_buf_is_valid(picker_buf) then return end
  picker_buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(picker_buf, "bufhidden", "wipe")
  vim.api.nvim_buf_set_option(picker_buf, "buftype", "nofile")
  vim.api.nvim_buf_set_option(picker_buf, "filetype", "raphael_picker")
end

-- open search prompt below picker
local function open_search()
  if not picker_win or not vim.api.nvim_win_is_valid(picker_win) then return end
  local cfg = vim.api.nvim_win_get_config(picker_win)
  local p_width = cfg.width
  local p_height = cfg.height or 1
  local p_row = (type(cfg.row) == "table" and cfg.row[false] or cfg.row) or 0
  local p_col = (type(cfg.col) == "table" and cfg.col[false] or cfg.col) or 0
  local s_row = p_row + (type(p_height) == "table" and p_height[false] or p_height)
  if s_row < 0 then s_row = 0 end

  search_buf = vim.api.nvim_create_buf(false, true)
  search_win = vim.api.nvim_open_win(search_buf, true, {
    relative = "editor", width = p_width, height = 1, row = s_row, col = p_col, style = "minimal", border = "rounded",
  })
  pcall(vim.api.nvim_buf_set_option, search_buf, "buftype", "prompt")
  vim.fn.prompt_setprompt(search_buf, "/ ")
  vim.api.nvim_set_current_win(search_win)
  vim.cmd("startinsert")

  vim.api.nvim_create_autocmd({ "TextChangedI", "TextChanged" }, {
    buffer = search_buf,
    callback = function()
      local lines = vim.api.nvim_buf_get_lines(search_buf, 0, -1, false)
      local q = table.concat(lines, "\n")
      q = q:gsub("^/ ", "")
      search_query = trim(q)
      local count = 0
      for _, items in pairs(themes.theme_map) do for _, t in ipairs(items) do if search_query == "" or t:lower():find(search_query:lower(), 1, true) then count = count + 1 end end end
      vim.notify(("Raphael search: '%s' (%d matches)"):format(search_query, count))
      render()
    end,
  })

  vim.keymap.set("i", "<Esc>", function()
    search_query = ""
    if search_win and vim.api.nvim_win_is_valid(search_win) then pcall(vim.api.nvim_win_close, search_win, true) end
    search_win, search_buf = nil, nil
    vim.cmd("stopinsert")
    if picker_win and vim.api.nvim_win_is_valid(picker_win) then pcall(vim.api.nvim_set_current_win, picker_win) end
    render()
  end, { buffer = search_buf })

  vim.keymap.set("i", "<CR>", function()
    search_query = ""
    if search_win and vim.api.nvim_win_is_valid(search_win) then pcall(vim.api.nvim_win_close, search_win, true) end
    search_win, search_buf = nil, nil
    vim.cmd("stopinsert")
    if picker_win and vim.api.nvim_win_is_valid(picker_win) then pcall(vim.api.nvim_set_current_win, picker_win) end
    render()
  end, { buffer = search_buf })
end

-- highlight helper for headers
local header_ns = vim.api.nvim_create_namespace("RaphaelHeader")
local function highlight_header_at(line_nr)
  if not picker_buf or not vim.api.nvim_buf_is_valid(picker_buf) then return end
  pcall(vim.api.nvim_buf_clear_namespace, picker_buf, header_ns, 0, -1)
  if not line_nr then return end
  pcall(vim.api.nvim_buf_add_highlight, picker_buf, header_ns, "Title", line_nr - 1, 0, -1)
end

-- do_preview + debounced wrapper
local function do_preview(theme)
  if not theme or not themes.is_available(theme) then return end
  if previewed == theme then return end
  previewed = theme
  local ok, err = pcall(vim.cmd.colorscheme, theme)
  if ok then
    vim.notify("Raphael preview: " .. theme)
  else
    vim.notify("Raphael preview failed: " .. tostring(err), vim.log.levels.WARN)
  end
  if core_ref and core_ref.state then
    core_ref.state.last_palette = theme
    if core_ref.save_state then pcall(core_ref.save_state) end
  end
  pcall(M.update_palette, theme)
end
local preview = debounce(100, do_preview)

-- open picker
function M.open(core)
  core_ref = core
  state_ref = core.state

  bookmarks = {}
  for _, b in ipairs(state_ref.bookmarks or {}) do bookmarks[b] = true end
  collapsed = type(state_ref.collapsed) == "table" and vim.deepcopy(state_ref.collapsed) or {}

  ensure_picker_buf()

  local total_h = math.max(6, math.floor(vim.o.lines * 0.6))
  local picker_w = math.floor(vim.o.columns * 0.5)
  local picker_row = math.floor((vim.o.lines - total_h) / 2)
  local picker_col = math.floor((vim.o.columns - picker_w) / 2)

  picker_win = vim.api.nvim_open_win(picker_buf, true, {
    relative = "editor", width = picker_w, height = total_h, row = picker_row, col = picker_col, style = "minimal", border = "rounded", title = "Raphael",
  })

  state_ref.previous = vim.g.colors_name

  -- keymaps
  vim.keymap.set("n", "q", function() close_picker(true) end, { buffer = picker_buf })
  vim.keymap.set("n", "<Esc>", function() close_picker(true) end, { buffer = picker_buf })

  -- collapse toggle
  vim.keymap.set("n", "c", function()
    local line = vim.api.nvim_get_current_line()
    local hdr = line:match("^%s*[]%s*(.+)%s*%(%d+%)%s*$")
    if hdr then
      collapsed[hdr] = not collapsed[hdr]
      state_ref.collapsed = vim.deepcopy(collapsed)
      if core_ref and core_ref.save_state then pcall(core_ref.save_state) end
      render()
    end
  end, { buffer = picker_buf })

  -- bookmark toggle (leader+b)
  vim.keymap.set("n", core_ref.config.leader .. "b", function()
    local line = vim.api.nvim_get_current_line()
    local theme = parse_line_theme(line)
    if not theme then return vim.notify("Raphael: no theme here", vim.log.levels.INFO) end
    if bookmarks[theme] then bookmarks[theme] = nil else bookmarks[theme] = true end
    local arr = {}
    for t, _ in pairs(bookmarks) do table.insert(arr, t) end
    state_ref.bookmarks = arr
    if core_ref and core_ref.save_state then pcall(core_ref.save_state) end
    render()
    pcall(M.update_palette, state_ref.last_palette or state_ref.current)
  end, { buffer = picker_buf })

  -- apply on Enter
  vim.keymap.set("n", "<CR>", function()
    local raw = vim.api.nvim_get_current_line()
    local theme = parse_line_theme(raw)
    vim.notify("CR pressed, raw line: " .. tostring(raw))
    vim.notify("CR pressed, parsed theme: " .. tostring(theme))
    if theme then
      vim.notify("is_available? " .. tostring(themes.is_available(theme)))
      if themes.is_available(theme) then
        if core_ref and core_ref.apply then
          pcall(core_ref.apply, theme)
          vim.notify("core.apply called for " .. theme)
        else
          vim.notify("core.apply missing", vim.log.levels.WARN)
        end
      else
        vim.notify("Theme not available: " .. theme, vim.log.levels.WARN)
      end
    else
      vim.notify("No theme on this line", vim.log.levels.INFO)
    end
    close_picker(false)
  end, { buffer = picker_buf })

  -- preview on cursor moved
  vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
    buffer = picker_buf,
    callback = function()
      local raw = vim.api.nvim_get_current_line()
      local theme = parse_line_theme(raw)
      local is_header = raw:match("^%s*[]%s*")
      if is_header then
        local pos = vim.api.nvim_win_get_cursor(picker_win)
        highlight_header_at(pos[1])
      else
        highlight_header_at(nil)
      end
      vim.notify("CursorMoved raw: " .. tostring(raw))
      vim.notify("CursorMoved parsed: " .. tostring(theme))
      if theme then
        preview(theme)
        state_ref.last_cursor = vim.api.nvim_win_get_cursor(picker_win)
        state_ref.last_palette = theme
        if core_ref and core_ref.save_state then pcall(core_ref.save_state) end
      end
    end,
  })

  -- open search
  vim.keymap.set("n", "/", function() open_search() end, { buffer = picker_buf })

  render()

  vim.schedule(function()
    if state_ref.last_cursor and type(state_ref.last_cursor) == "table" then
      pcall(vim.api.nvim_win_set_cursor, picker_win, state_ref.last_cursor)
    else
      local lines = vim.api.nvim_buf_get_lines(picker_buf, 0, -1, false)
      for i, l in ipairs(lines) do
        local theme = parse_line_theme(l)
        if theme and state_ref.current == theme then
          pcall(vim.api.nvim_win_set_cursor, picker_win, { i, 0 })
          break
        end
      end
    end
    pcall(M.update_palette, state_ref.last_palette or state_ref.current)
  end)
end

return M
