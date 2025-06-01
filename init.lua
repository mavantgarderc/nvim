-- Core Directory
require("core.bootstrap")
require("core.options")
require("core.keymaps")
require("core.keymapviewer")
require("core.themepicker")

-- Plugins Directory
require("lazy").setup("plugins")

-- After Directory
--require("after.plugin")

-- Colors
--vim.cmd.colorscheme("gruvbox")
