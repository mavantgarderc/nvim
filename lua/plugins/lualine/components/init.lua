local M = {}

-- Load all components
local git = require("plugins.lualine.components.git")

M.diagnostics = require("plugins.lualine.components.diagnostics")
M.diff = git.diff
M.branch = git.branch
M.location = require("plugins.lualine.components.location")
M.progress = require("plugins.lualine.components.progress")
M.filetype = require("plugins.lualine.components.filetype").filetype
M.toggle_filetype_text = require("plugins.lualine.components.filetype").toggle_filetype_text

return M
