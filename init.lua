-- Core Directory
require("core.bootstrap")
require("core.options")
require("core.keymaps")
--require("core.keymapviewer")

-- Plugins Directory
require("lazy").setup("plugins")

-- After Directory
require("after.plugin")

-- Colors
require("colors")
vim.cmd.colorscheme("gruvbox")

