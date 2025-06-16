-- Core Directory
require("core.healthcheck")
require("core.bootstrap")
require("core.keymaps")
require("core.options")

-- Plugins Directory
require("lazy").setup("plugins")

--require("core.themepicker")
vim.cmd.colorscheme("kanagawa")
