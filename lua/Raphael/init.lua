local M = {}

-- Import submodules
local theme_loader = require("Raphael.scripts.loader")
local theme_picker = require("Raphael.scripts.picker")
local theme_preview = require("Raphael.scripts.preview")
local theme_cycler = require("Raphael.scripts.cycler")
local autocmds = require("Raphael.scripts.autocmds")
local commands = require("Raphael.scripts.cmds")
local keymaps = require("Raphael.keymaps")

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
