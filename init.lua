vim.loader.enable()

-- Core Directory
require("core.healthcheck")
require("core.bootstrap")
require("core.options")

-- Keymaps
require("core.keymaps.core")
require("core.keymaps.fileactions")
require("core.keymaps.navigation")
require("core.keymaps.visualkeys")

-- Plugins Directory
require("lazy").setup("plugins")

-- require("core.themepicker")
-- vim.cmd.colorscheme("kanagawa-dragon")
--vim.cmd.colorscheme("terafox")
-- vim.cmd.colorscheme("base16-da-one-sea")
vim.cmd.colorscheme("base16-gruvbox-material-dark-hard")
