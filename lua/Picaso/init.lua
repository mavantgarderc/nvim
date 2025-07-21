local M = {}

-- Import submodules
local theme_loader = require("Picaso.theme-loader")
local theme_picker = require("Picaso.theme-picker")
local theme_preview = require("Picaso.theme-preview")
local theme_cycler = require("Picaso.theme-cycler")
local autocmds = require("Picaso.autocmds")
local commands = require("Picaso.commands")
local keymaps = require("Picaso.keymaps")

-- Initialize the theme manager
function M.setup(opts)
    opts = opts or {}

    -- Initialize submodules
    theme_loader.setup(opts)
    autocmds.setup()
    commands.setup()
    keymaps.setup(opts.keymaps)
end

-- Public API
M.select_theme = theme_picker.select_theme
M.cycle_next_theme = theme_cycler.cycle_next_theme
M.load_theme = theme_loader.load_theme
M.get_current_theme = theme_loader.get_current_theme
M.preview_themes = theme_preview.preview_all_themes

return M
