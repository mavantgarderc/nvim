return{
    "lewis6991/gitsigns.nvim",
    config = function()
        require("after.plugin.git-stuff")
        require("gitsigns")
    end
}
