local M = {}

local theme_loader = require("Raphael.loader")
local notify = vim.notify
local log = vim.log
local defer_fn = vim.defer_fn

-- === Theme Preview ===
function M.preview_all_themes(delay)
  local themes = theme_loader.get_theme_list()
  delay = delay or 700
  local original_theme = theme_loader.get_current_theme()

  if #themes == 0 then
    notify("No themes available", log.levels.WARN)
    return
  end

  local function restore_theme()
    if original_theme then
      theme_loader.load_theme(original_theme)
    end
  end

  local preview_index = 1
  local function preview_next()
    if preview_index > #themes then
      restore_theme()
      notify("Preview complete", log.levels.INFO)
      return
    end

    local theme = themes[preview_index]
    notify(
      "Previewing: " .. theme .. " (" .. preview_index .. "/" .. #themes .. ")",
      log.levels.INFO,
      { title = "Theme Preview" }
    )

    theme_loader.load_theme(theme, true)
    preview_index = preview_index + 1
    defer_fn(preview_next, delay)
  end

  preview_next()
end

-- === Single Theme Preview ===
function M.preview_theme(theme_name, duration)
  if not theme_name or not theme_loader.is_theme_available(theme_name) then
    notify("Theme '" .. (theme_name or "nil") .. "' not available", log.levels.ERROR)
    return
  end

  duration = duration or 2000
  local original_theme = theme_loader.get_current_theme()

  theme_loader.load_theme(theme_name, true)
  notify("Previewing: " .. theme_name, log.levels.INFO, { title = "Theme Preview" })

  defer_fn(function()
    if original_theme then
      theme_loader.load_theme(original_theme)
      notify("Restored: " .. original_theme, log.levels.INFO)
    end
  end, duration)
end

return M
