-- bootstrap lazy
require("core.bootstrap")
-- vim-options
require("core.options")
-- plugins
require("lazy").setup("plugins")
-- after
-- require("after")


-- Set a default global colorscheme
require("core.thememanager").setup()