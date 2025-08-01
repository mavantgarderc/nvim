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

-- require("Raphael").setup()
vim.cmd.colorscheme("base16-gruvbox-material-dark-hard")
