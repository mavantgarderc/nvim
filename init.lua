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

-- vim.cmd.colorscheme("kanagawa-wave")
-- vim.cmd.colorscheme("terafox")
-- vim.cmd.colorscheme("base16-da-one-sea")
-- vim.cmd.colorscheme("base16-gruvbox-material-dark-hard")
-- vim.cmd.colorscheme("gotham")
-- vim.cmd.colorscheme("base16-gruvbox-material-dark-hard")
require("Raphael").setup()
-- vim.cmd.colorscheme("kanagawa-paper-ink")
