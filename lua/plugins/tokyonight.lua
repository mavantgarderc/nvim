return{
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
        vim.cmd.colorscheme "tokyonight-night"
        -- vim.cmd.colorscheme "tokyonight-moon"
        -- vim.cmd.colorscheme "tokyonight-storm"
        -- vim.cmd.colorscheme "tokyonight-day"
    end
}