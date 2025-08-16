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

vim.cmd.colorscheme("kanagawa-paper-ink") -- default themes of your choice
require("Raphael").setup()
