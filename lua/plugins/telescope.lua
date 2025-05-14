return{
    {
        "nvim-telescope/telescope.nvim",
        tag = '0.1.5',
	    dependencies = {
            "nvim-lua/plenary.nvim"
        },
    },
    {
        "nvim-telescope/telescope-ui-select.nvim",
        config = function()
            extensions = {
                ["ui-select"] = {
                    require("telescope.themes").get_dropdown{}
                }
            }
        end
    },
}
