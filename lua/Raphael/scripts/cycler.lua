-- File: Raphael/scripts/cycler.lua
local vim = vim
local defer_fn = vim.defer_fn
local notify = vim.notify
local log = vim.log
local api = vim.api
local fn = vim.fn
local map = vim.keymap.set
local fetch_fn = vim.fetch_fn

local colors_config = require("Raphael.colors")
local loader = require("Raphael.scripts.loader")

local M = {}

-- Cycler state
local cycler_state = {
  colorschemes = {},
  current_index = 1,
  cycle_type = "all", -- "all", "toml", "builtin"
  auto_cycle = false,
  auto_cycle_timer = nil,
  auto_cycle_interval = 5000, -- 5 seconds
}

-- Helper: get colorschemes by type
local local_type_map = {
  toml = colors_config.get_toml_colorschemes,
  builtin = colors_config.get_builtin_colorschemes,
  dark = colors_config.get_dark_colorschemes,
  light = colors_config.get_light_colorschemes,
  all = colors_config.get_all_colorschemes,
}

local function init_cycler(cycle_type)
  cycler_state.cycle_type = cycle_type or "all"
  local fetch_fn = local_type_map[cycler_state.cycle_type] or colors_config.get_all_colorschemes
  cycler_state.colorschemes = fetch_fn()

  local current_colorscheme = loader.get_current_colorscheme()
  cycler_state.current_index = 1

  for i, cs in ipairs(cycler_state.colorschemes) do
    if cs.name == current_colorscheme.name and cs.type == current_colorscheme.type then
      cycler_state.current_index = i
      break
    end
  end
end

-- Directional cycling helper
local function cycle_index(delta)
  local n = #cycler_state.colorschemes
  if n == 0 then return nil end

  cycler_state.current_index = ((cycler_state.current_index - 1 + delta) % n) + 1
  return cycler_state.colorschemes[cycler_state.current_index]
end

-- Apply a colorscheme and notify
local function apply_colorscheme(cs)
  if not cs then return nil end
  local success = loader.apply_colorscheme(cs.name, cs.type)
  if success then
    notify("Switched to: " .. cs.display_name, log.levels.INFO)
    return cs
  end
end

function M.cycle_next(cycle_type)
  init_cycler(cycle_type)
  return apply_colorscheme(cycle_index(1))
end

function M.cycle_previous(cycle_type)
  init_cycler(cycle_type)
  return apply_colorscheme(cycle_index(-1))
end

-- Random cycling
function M.cycle_random(cycle_type)
  init_cycler(cycle_type)
  local n = #cycler_state.colorschemes
  if n == 0 then return nil end

  local random_index
  if n == 1 then
    random_index = 1
  else
    repeat
      random_index = math.random(1, n)
    until random_index ~= cycler_state.current_index
  end

  cycler_state.current_index = random_index
  return apply_colorscheme(cycler_state.colorschemes[random_index])
end

-- Cycle to a specific colorscheme
function M.cycle_to(name, scheme_type)
  init_cycler()
  for i, cs in ipairs(cycler_state.colorschemes) do
    if cs.name == name and (not scheme_type or cs.type == scheme_type) then
      cycler_state.current_index = i
      return apply_colorscheme(cs)
    end
  end
  notify("Colorscheme not found: " .. name, log.levels.WARN)
  return nil
end

-- Auto-cycling
local function auto_cycle_fn()
  if not cycler_state.auto_cycle then return end
  local cs = cycle_index(1)
  if cs then loader.apply_colorscheme(cs.name, cs.type) end
  cycler_state.auto_cycle_timer = defer_fn(auto_cycle_fn, cycler_state.auto_cycle_interval)
end

function M.start_auto_cycle(cycle_type, interval)
  M.stop_auto_cycle()
  init_cycler(cycle_type)
  cycler_state.auto_cycle = true
  cycler_state.auto_cycle_interval = interval or 5000
  cycler_state.auto_cycle_timer = defer_fn(auto_cycle_fn, cycler_state.auto_cycle_interval)
  notify("Auto-cycle started (" .. cycle_type .. ", " .. (cycler_state.auto_cycle_interval / 1000) .. "s interval)",
    log.levels.INFO)
end

function M.stop_auto_cycle()
  cycler_state.auto_cycle = false
  if cycler_state.auto_cycle_timer then
    fn.timer_stop(cycler_state.auto_cycle_timer)
    cycler_state.auto_cycle_timer = nil
  end
  notify("Auto-cycle stopped", log.levels.INFO)
end

function M.toggle_auto_cycle(cycle_type, interval)
  if cycler_state.auto_cycle then
    M.stop_auto_cycle()
  else
    M.start_auto_cycle(cycle_type, interval)
  end
end

-- Get cycle status
function M.get_cycle_status()
  return {
    active = cycler_state.auto_cycle,
    type = cycler_state.cycle_type,
    interval = cycler_state.auto_cycle_interval,
    current_index = cycler_state.current_index,
    total_colorschemes = #cycler_state.colorschemes,
    current_colorscheme = cycler_state.colorschemes[cycler_state.current_index],
  }
end

-- List cycling through a given list
function M.cycle_through_list(names, forward)
  if not names or #names == 0 then
    notify("No colorschemes provided for cycling", log.levels.WARN)
    return
  end

  local current = loader.get_current_colorscheme().name
  local index = vim.tbl_indexof(names, current) or 1
  local n = #names
  local delta = (forward == false) and -1 or 1
  local new_index = ((index - 1 + delta) % n) + 1
  local target_name = names[new_index]

  for _, cs in ipairs(colors_config.get_all_colorschemes()) do
    if cs.name == target_name then
      cycler_state.current_index = new_index
      return apply_colorscheme(cs)
    end
  end

  notify("Colorscheme not found: " .. target_name, log.levels.WARN)
  return nil
end

-- Show cycle info
function M.show_cycle_info()
  local status = M.get_cycle_status()
  local lines = {
    "Raphael Cycler Status:",
    "",
    "Auto-cycle: " .. (status.active and "Active" or "Inactive"),
  }
  if status.active then
    table.insert(lines, "Type: " .. status.type)
    table.insert(lines, "Interval: " .. (status.interval / 1000) .. " seconds")
  end
  table.insert(lines, "")
  table.insert(lines, "Available colorschemes: " .. status.total_colorschemes)
  table.insert(lines, "Current position: " .. status.current_index .. "/" .. status.total_colorschemes)
  if status.current_colorscheme then
    table.insert(lines, "Current theme: " .. status.current_colorscheme.display_name)
  end

  table.insert(lines, "")
  table.insert(lines, "Colorschemes in cycle:")
  for i, cs in ipairs(cycler_state.colorschemes) do
    local prefix = (i == status.current_index) and "► " or "  "
    local type_indicator = cs.type == "toml" and " [TOML]" or " [Built-in]"
    table.insert(lines, prefix .. cs.display_name .. type_indicator)
  end

  local buf = api.nvim_create_buf(false, true)
  api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  local o = vim.o
  local width = math.min(60, o.columns - 4)
  local height = math.min(#lines + 2, o.lines - 4)

  local win = api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((o.lines - height) / 2),
    col = math.floor((o.columns - width) / 2),
    style = "minimal",
    border = "rounded",
    title = " Cycle Info ",
    title_pos = "center",
  })

  api.nvim_buf_set_option(buf, "bufhidden", "wipe")
  api.nvim_buf_set_option(buf, "buftype", "nofile")
  api.nvim_buf_set_option(buf, "swapfile", false)
  api.nvim_buf_set_option(buf, "modifiable", false)

  local close_win = function() api.nvim_win_close(win, true) end
  map("n", "<buffer>", close_win, { buffer = buf })
  map("n", "q", close_win, { buffer = buf })
  map("n", "<Esc>", close_win, { buffer = buf })
end

function M.get_cycle_colorschemes()
  return cycler_state.colorschemes
end

return M
