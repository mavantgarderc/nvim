local M = {}

local git = require("plugins.lualine.components.git")

M.diagnostics = require("plugins.lualine.components.diagnostics")
M.diff = git.diff
M.last_commit = git.last_commit
M.branch = git.branch
M.last_commit = git.last_commit
M.ahead_behind = git.ahead_behind
M.location = require("plugins.lualine.components.location")
M.progress = require("plugins.lualine.components.progress")
M.filetype = require("plugins.lualine.components.filetype").filetype
M.toggle_filetype_text = require("plugins.lualine.components.filetype").toggle_filetype_text
M.lsp = require("plugins.lualine.components.lsp")
M.build_status = require("plugins.lualine.components.build_status")
M.ci = require("plugins.lualine.components.ci")
M.coverage = require("plugins.lualine.components.coverage")
M.container = require("plugins.lualine.components.container")
M.project = require("plugins.lualine.components.project")
M.deps = require("lua.plugins.lualine.components.deps")

return M
