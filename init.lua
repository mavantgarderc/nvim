vim.loader.enable()

-- Core Directory
require("core.healthcheck")
require("core.bootstrap")
require("core.options")

-- Plugins Directory
require("lazy").setup("plugins")

-- Keymaps
require("core.keymaps.core")
require("core.keymaps.fileactions")
require("core.keymaps.navigation")
require("core.keymaps.visualkeys")

-- require("core.themepicker")
-- vim.cmd.colorscheme("kanagawa-dragon")
-- vim.cmd.colorscheme("terafox")
-- vim.cmd.colorscheme("base16-da-one-sea")
-- vim.cmd.colorscheme("base16-gruvbox-material-dark-hard")
vim.cmd.colorscheme("gotham")
