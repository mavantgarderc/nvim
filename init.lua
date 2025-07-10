vim.loader.enable()

-- Core Directory
require("core.healthcheck")
require("core.bootstrap")
require("core.options")
require("core.depgraph")

-- Keymaps
require("core.keymaps.core")
require("core.keymaps.fileactions")
require("core.keymaps.navigation")
require("core.keymaps.visualkeys")

-- Plugins Directory
require("lazy").setup("plugins")

require("core.themepicker")
--vim.cmd.colorscheme("kanagawa-dragon")
--vim.cmd.colorscheme("terafox")
