-- Core Directory
require("core.bootstrap")
require("core.options")
require("core.keymaps")
require("core.healthcheck")
--require("core.themepicker")

-- Plugins Directory
require("lazy").setup("plugins")

vim.cmd.colorscheme("kanagawa")
