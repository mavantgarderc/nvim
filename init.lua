-- Core Directory
require("core.healthcheck")
require("core.bootstrap")
require("core.options")
require("core.keymaps")

-- Plugins Directory
require("lazy").setup("plugins")

--require("core.themepicker")
vim.cmd.colorscheme("kanagawa")
