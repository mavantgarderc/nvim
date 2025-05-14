return{
    "nvim-lualine/lualine.nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        require("lualine").setup({
            options = {
                icons_enabled = true,
                theme = "auto",
                component_separators = { left = '', right = ''},
                section_separators = { left = '', right = ''},
                disabled_filetypes = {
                    statusline = {},
                    winbar = {},
                },
                ignore_focus = {},
                always_divide_middle = true,
                always_show_tabline = true,
                globalstatus = false,
                refresh = {
                    statusline = 100,
                    tabline = 100,
                    winbar = 100,
                }},
            sections = {
                lualine_a = { "mode'"},
                lualine_b = { "branch" },
                lualine_c = { "filename" },
                lualine_x = { "fileformat", "filetype" },
                lualine_y = { "progress" },
                lualine_z = { "location" }
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { "filename" },
                lualine_x = { "location" },
                lualine_y = {},
                lualine_z = {}
            },
            tabline = {},
            winbar = {},
            inactive_winbar = {},
            extensions = { "fugitive" }
        })
    end
    -- Keybinding to toggle the statusline
    vim.keymap.set("n", "<leader>ss", function()
        require("lualine").toggle()  -- Toggle the statusline visibility
    end, { desc = "Toggle Statusline" })

    -- Initialize nvim-navic (for LSP navigation)
    require("nvim-navic").setup({
    separator = " > ",  -- Separator between navigation levels
    depth_limit = 3,    -- Limit the depth of navigation context
    icons = {
        File = "",
        Module = "",
        Namespace = "",
        Package = "",
        Class = "ﴯ",
        Method = "",
        Property = "",
        Field = "",
        Constructor = "",
        Enum = "",
        Interface = "ﰮ",
        Function = "",
        Variable = "",
        Constant = "",
        String = "",
        Number = "",
        Boolean = "⊨",
        Array = "",
        Object = "",
        Key = "",
        Null = "NULL",
        EnumMember = "",
        Struct = "",
        Event = "",
        Operator = "",
        TypeParameter = "",
    },
    })
}