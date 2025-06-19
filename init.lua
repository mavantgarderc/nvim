--[[
And for them whom following Grimnir's path, The Allfather
obliged be armored by 100% layout seiðr... ]]

-- Core Directory
require("core.healthcheck")
require("core.bootstrap")
require("core.options")
-- Keymaps
require("core.keymaps.buffer")
require("core.keymaps.core")
require("core.keymaps.fileactions")
require("core.keymaps.visualkeys")

-- Plugins Directory
require("lazy").setup("plugins")

--require("core.themepicker")
vim.cmd.colorscheme("kanagawa")
