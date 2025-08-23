-- File: Raphael/scripts/picker.lua
local api = vim.api
local theme_loader = require("Raphael.scripts.loader")
local colors = require("Raphael.colors")

local M = {}

-- ===== State =====
local state = {
  categories = {},
  win = nil,
  buf = nil,
  prompt_buf = nil,
  prompt_win = nil,
  last_preview = nil,
}

-- ===== Helpers =====
local function fuzzy_match(str, query)
  str, query = str:lower(), query:lower()
  local i = 1
  for c in query:gmatch(".") do
    i = str:find(c, i, true)
    if not i then return false end
    i = i + 1
  end
  return true
end

local function flatten_categories()
  local lines = {}
  local line_map = {}
  for _, cat in ipairs(state.categories) do
    table.insert(lines, (cat.collapsed and "[+] " or "[-] ") .. cat.category)
    table.insert(line_map, { category = cat })
    if not cat.collapsed then
      for _, cs in ipairs(cat.themes) do
        table.insert(lines, "  " .. cs.name)
        table.insert(line_map, { cs = cs })
      end
    end
  end
  return lines, line_map
end

-- ===== Render =====
local function render()
  if not (state.buf and api.nvim_buf_is_valid(state.buf)) then return end
  api.nvim_buf_set_option(state.buf, "modifiable", true)
  local lines, line_map = flatten_categories()
  state.line_map = line_map
  if #lines == 0 then lines = { "[No themes]" } end
  api.nvim_buf_set_lines(state.buf, 0, -1, false, lines)
  api.nvim_buf_set_option(state.buf, "modifiable", false)
end

-- ===== Picker Creation =====
local function create_input_prompt()
  state.prompt_buf = api.nvim_create_buf(false, true)
  local width = math.floor(vim.o.columns * 0.5)
  local row = math.floor(vim.o.lines / 2)
  local col = math.floor((vim.o.columns - width) / 2)

  state.prompt_win = api.nvim_open_win(state.prompt_buf, true, {
    relative = "editor",
    row = row,
    col = col,
    width = width,
    height = 1,
    style = "minimal",
    border = "single",
  })
  api.nvim_buf_set_option(state.prompt_buf, "buftype", "prompt")
  vim.fn.prompt_setprompt(state.prompt_buf, "Search: ")

  vim.cmd(string.format([[
    autocmd TextChangedI <buffer=%d> lua require("Raphael.scripts.picker").on_prompt_changed()
    autocmd TextChanged <buffer=%d> lua require("Raphael.scripts.picker").on_prompt_changed()
  ]], state.prompt_buf, state.prompt_buf))
end

local function create_list_window()
  state.buf = api.nvim_create_buf(false, true)
  local width = math.floor(vim.o.columns * 0.5)
  local height = math.floor(vim.o.lines * 0.6)
  local row = math.floor((vim.o.lines - height) / 2) + 1
  local col = math.floor((vim.o.columns - width) / 2)

  state.win = api.nvim_open_win(state.buf, true, {
    relative = "editor",
    row = row,
    col = col,
    width = width,
    height = height,
    style = "minimal",
    border = "single",
  })
  api.nvim_buf_set_option(state.buf, "modifiable", false)

  -- Live preview on cursor move
  api.nvim_create_autocmd("CursorMoved", {
    buffer = state.buf,
    callback = function()
      local line_nr = unpack(api.nvim_win_get_cursor(state.win))
      local entry = state.line_map[line_nr]
      if entry and entry.cs and state.last_preview ~= entry.cs.name then
        theme_loader.apply_colorscheme(entry.cs.name, entry.cs.type)
        state.last_preview = entry.cs.name
      end
    end,
  })
end

-- ===== Event Handlers =====
function M.on_prompt_changed()
  local ok, line = pcall(api.nvim_get_current_line)
  if not ok or not line then return end
  local query = line:gsub("^Search:%s*", "")
  for _, cat in ipairs(state.categories) do
    cat.collapsed = false
    if query ~= "" then
      local matched = false
      for _, cs in ipairs(cat.themes) do
        if fuzzy_match(cs.name, query) then
          matched = true
        end
      end
      if not matched then cat.collapsed = true end
    end
  end
  render()
end

local function accept_selection()
  local line_nr = unpack(api.nvim_win_get_cursor(state.win))
  local entry = state.line_map[line_nr]
  if not entry then return end

  if entry.category then
    entry.category.collapsed = not entry.category.collapsed
    render()
  elseif entry.cs then
    theme_loader.apply_colorscheme(entry.cs.name, entry.cs.type)
    vim.notify("Applied colorscheme: " .. entry.cs.name, vim.log.levels.INFO)
    api.nvim_win_close(state.win, true)
    api.nvim_win_close(state.prompt_win, true)
  end
end

-- ===== Public =====
function M.open_picker()
  state.categories = colors.get_all_colorschemes_grouped()
  for _, cat in ipairs(state.categories) do cat.collapsed = false end

  create_input_prompt()
  create_list_window()
  render()

  vim.keymap.set("n", "<CR>", accept_selection, { buffer = state.buf })
  vim.keymap.set("n", "q", function()
    api.nvim_win_close(state.win, true)
    api.nvim_win_close(state.prompt_win, true)
  end, { buffer = state.buf })
end

return M
