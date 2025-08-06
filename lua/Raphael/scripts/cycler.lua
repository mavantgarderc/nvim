local M = {}

local notify = vim.notify
local log = vim.log

local theme_loader = require("Raphael.scripts.loader")

-- State
local current_theme_index = 1

-- === Theme Cycling ===
function M.cycle_next_theme()
  local themes = theme_loader.get_theme_list()

  if #themes == 0 then
    notify("No themes available", log.levels.WARN)
    return
  end

  current_theme_index = current_theme_index % #themes + 1
  local theme = themes[current_theme_index]

  if theme_loader.load_theme(theme) then
    notify("Theme: " .. theme .. " (" .. current_theme_index .. "/" .. #themes .. ")",
      log.levels.INFO, { title = "Theme Cycler" })
  end
end

function M.cycle_prev_theme()
  local themes = theme_loader.get_theme_list()

  if #themes == 0 then
    notify("No themes available", log.levels.WARN)
    return
  end

  current_theme_index = current_theme_index - 1
  if current_theme_index < 1 then current_theme_index = #themes end

  local theme = themes[current_theme_index]

  if theme_loader.load_theme(theme) then
    notify( "Theme: " .. theme .. " (" .. current_theme_index .. "/" .. #themes .. ")",
      log.levels.INFO, { title = "Theme Cycler" })
  end
end

-- === Random Theme ===
function M.random_theme()
  local themes = theme_loader.get_theme_list()

  if #themes == 0 then
    notify("No themes available", log.levels.WARN)
    return
  end

  math.randomseed(os.time())
  local random_index = math.random(1, #themes)
  local theme = themes[random_index]

  current_theme_index = random_index

  if theme_loader.load_theme(theme) then
    notify("Random theme: " .. theme .. " (" .. random_index .. "/" .. #themes .. ")",
      log.levels.INFO, { title = "Theme Cycler" })
  end
end

-- === Getters ===
function M.get_current_index() return current_theme_index end

function M.set_current_index(index)
  local themes = theme_loader.get_theme_list()
  if index >= 1 and index <= #themes then current_theme_index = index end
end

return M
