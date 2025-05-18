-- bootstrap lazy
require("core.bootstrap")
-- vim-options
require("core.options")
-- keymaps
require("core.keymaps")
-- plugins
require("lazy").setup("plugins")
-- after
require("after.plugin")

-- Set a default global colorscheme
-- require("after.plugin.colors").setup()
vim.cmd.colorscheme("catppuccin")
