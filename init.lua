-- Core Directory
require("core.bootstrap")
require("core.options")
require("core.keymaps")
require("core.healthcheck")

-- Plugins Directory
require("lazy").setup("plugins")

--require("core.themepicker")
vim.cmd.colorscheme("kanagawa")
