-- File: Raphael/scripts/picker.lua
local api = vim.api
local theme_loader = require("Raphael.scripts.loader")

local M = {}

-- ===== State =====
local state = {
  themes = {},
  filtered = {},
  win = nil,
  buf = nil,
  prompt_buf = nil,
  prompt_win = nil,
  prev = nil,
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

local function get_display_name(cs)
  return cs.name
end

-- ===== Render =====
local function render()
  if not (state.buf and api.nvim_buf_is_valid(state.buf)) then return end
  api.nvim_buf_set_option(state.buf, "modifiable", true)
  local lines = {}
  for _, cs in ipairs(state.filtered) do
    table.insert(lines, get_display_name(cs))
  end
  if #lines == 0 then lines = { "[No matches]" } end
  api.nvim_buf_set_lines(state.buf, 0, -1, false, lines)
  api.nvim_buf_set_option(state.buf, "modifiable", false)
end

-- ===== Filtering =====
local function update_filtered(query)
  if not query or query == "" then
    state.filtered = vim.deepcopy(state.themes)
  else
    state.filtered = {}
    for _, cs in ipairs(state.themes) do
      if fuzzy_match(cs.name, query) then
        table.insert(state.filtered, cs)
      end
    end
  end
  render()
end

-- ===== Picker Creation =====
local function create_input_prompt()
  state.prompt_buf = api.nvim_create_buf(false, true)
  local width = math.floor(vim.o.columns * 0.5)
  local height = math.floor(vim.o.lines * 0.6)
  local row = math.floor((vim.o.lines - height) / 2) - 1
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
  local height = math.floor(vim.o.lines * 0.6) - 2
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
end

-- ===== Event Handlers =====
function M.on_prompt_changed()
  local ok, line = pcall(api.nvim_get_current_line)
  if not ok or not line then return end
  local query = line:gsub("^Search:%s*", "")
  update_filtered(query)
end

local function accept_selection()
  local idx = unpack(api.nvim_win_get_cursor(state.win))
  local cs = state.filtered[idx]
  if cs and cs.name then
    theme_loader.apply_colorscheme(cs.name, cs.type)
    vim.notify("Applied colorscheme: " .. cs.name, vim.log.levels.INFO)
    api.nvim_win_close(state.win, true)
    api.nvim_win_close(state.prompt_win, true)
  end
end

-- ===== Public =====
function M.open_picker()
  state.themes = theme_loader.get_available_colorschemes()
  state.filtered = vim.deepcopy(state.themes)
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
