local M = {}

M.healthcheck = require("core.healthcheck")
M.bootstrap = require("core.bootstrap")
M.options = require("core.options")

M.key_core = require("core.keymaps.core")
M.key_fileaction = require("core.keymaps.fileactions")
M.key_navigation = require("core.keymaps.navigation")
M.key_visual = require("core.keymaps.visualkeys")

require("core.sql_env").setup()
require("core.sql_output").setup()

return M
