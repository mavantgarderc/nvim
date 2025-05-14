-- bootstrap lazy
require("core.bootstrap")
-- vim-options
require("core.options")
-- plugins
require("lazy").setup("plugins")
-- after

-- Set a default global colorscheme
require("after.plugin.colors").setup()