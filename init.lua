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

-- Plugins Directory
require("lazy").setup("plugins")

-- Disable blinking entirely (steady cursor)
vim.opt.guicursor = ""

-- OR control blink speed (adjust milliseconds)
vim.opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:blinkwait500-blinkoff200-blinkon250"

-- require("core.themepicker")
vim.cmd.colorscheme("kanagawa-dragon")
--vim.cmd.colorscheme("retrobox")
