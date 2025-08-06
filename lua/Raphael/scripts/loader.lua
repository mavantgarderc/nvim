local M = {}

local cmd = vim.cmd
local notify = vim.notify
local fn = vim.fn
local log = vim.log
local api = vim.api

local config = require("Raphael.colors")

-- Current theme state
local current_theme = nil

-- === Theme Loader ===
function M.load_theme(theme_name, is_preview)
  if not theme_name then return false end
  if not is_preview and current_theme == theme_name then return true end

  local ok, err = pcall(cmd.colorscheme, theme_name)
  if ok then
    if not is_preview then current_theme = theme_name end
    return true
  else
    notify("Failed to load theme '" .. theme_name .. "': " .. err, log.levels.ERROR)
    return false
  end
end

-- === Theme validation ===
function M.is_theme_available(theme_name)
  if not theme_name then return false end
  for _, name in ipairs(fn.getcompletion("", "color")) do
    if name == theme_name then return true end
  end
  return false
end

-- === Get theme list ===
function M.get_theme_list()
  local themes = {}
  for _, variants in pairs(config.theme_map or {}) do
    for _, theme in ipairs(variants) do
      if M.is_theme_available(theme) then table.insert(themes, theme) end
    end
  end

  -- Fallback: get all available colorschemes if config is empty
  if #themes == 0 then themes = fn.getcompletion("", "color") end

  return themes
end
-- === Get theme categories ===
function M.get_theme_categories()
  local categories = {}
  for category, variants in pairs(config.theme_map or {}) do
    local available_themes = {}
    for _, theme in ipairs(variants) do
      if M.is_theme_available(theme) then
        table.insert(available_themes, theme)
      end
    end
    if #available_themes > 0 then
      categories[category] = available_themes
    end
  end
  return categories
end

-- === Auto-set Theme Based on Filetype (Toggle) ===
M.auto_theme_enabled = true -- Default state

function M.toggle_auto_theme()
  M.auto_theme_enabled = not M.auto_theme_enabled
  local status = M.auto_theme_enabled and "enabled" or "disabled"
  print("Auto theme switching " .. status)
end

function M.set_theme_by_filetype(buf)
  if not config.filetype_themes or not M.auto_theme_enabled then return end
  local ft = api.nvim_buf_get_option(buf or 0, "filetype")
  local theme = config.filetype_themes[ft]
  if theme and M.is_theme_available(theme) then M.load_theme(theme) end
end

-- === Getters ===
function M.get_current_theme() return current_theme end

-- === Setup ===
function M.setup(opts)
  opts = opts or {}
  -- Any loader-specific setup can go here
end

return M
