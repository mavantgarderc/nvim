return{ 
    "catppuccin/nvim", 
    name = "catppuccin", 
    priority = 1000,
    config = function()
    local mocha = require("catppuccin.palettes").get_palette "mocha"
        vim.cmd.colorscheme("mocha")
    end
}