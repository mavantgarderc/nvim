vim.loader.enable()

-- Core Directory
require("core.healthcheck")
require("core.bootstrap")
require("core.options")
-- Keymaps
require("core.keymaps.frames")
require("core.keymaps.core")
require("core.keymaps.fileactions")
require("core.keymaps.visualkeys")

-- Plugin Keymaps
require("core.keymaps.telescope")


-- Plugins Directory
require("lazy").setup("plugins")

--vim.cmd.colorscheme("kanagawa-dragon")
require("core.themepicker")
-- vim.cmd.colorscheme("slate")
