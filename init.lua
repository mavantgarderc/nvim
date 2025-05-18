-- Core Directory
require("core.bootstrap")
require("core.options")
require("core.keymaps")

-- Plugins Directory
require("lazy").setup("plugins")

-- After Directory
require("after.plugin")

require("after.plugin.colors").setup()
--vim.cmd.colorscheme("kanagawa-dragon")
