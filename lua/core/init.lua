vim.opt.runtimepath:append(vim.fn.stdpath("config"))
vim.opt.runtimepath:append(vim.fn.stdpath("config") .. "/lua")
package.path = package.path .. ";" .. vim.fn.stdpath("config") .. "/?.lua" .. ";" .. vim.fn.stdpath("config") .. "/?/init.lua"

local M = {}

M.healthcheck = require("core.healthcheck")
M.bootstrap = require("core.bootstrap")
M.options = require("core.options")

M.key_core = require("core.keymaps.core")
M.key_fileaction = require("core.keymaps.fileactions")
M.key_navigation = require("core.keymaps.navigation")
M.key_visual = require("core.keymaps.visualkeys")

return M
