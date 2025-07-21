-- lua/theme-manager/theme-loader.lua
local M = {}

local config = require("Picaso.colors")
local cmd = vim.cmd
local notify = vim.notify
local fn = vim.fn
local log = vim.log

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

-- === Auto-set Theme Based on Filetype ===
function M.set_theme_by_filetype(buf)
    if not config.filetype_themes then return end

    local api = vim.api
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
