-- Core Directory
require("core.bootstrap")
require("core.options")
require("core.keymaps")
require("core.themepicker")

-- Plugins Directory
require("lazy").setup("plugins")

--vim.cmd.colorscheme("gruvbox")
