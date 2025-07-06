return {
    "folke/which-key.nvim",
    event = "VimEnter",
    config = function()
        local status_ok, which_key = pcall(require, "which-key")
        if not status_ok then return end

        local g = vim.g
        local setup = {
            delay = 0,
            plugins = {
                marks = true,
                registers = true,
                spelling = {
                    enabled = true,
                    suggestions = 20,
                },
                presets = {
                    operators = false,
                    motions = true,
                    text_objects = true,
                    windows = true,
                    nav = true,
                    z = true,
                    g = true,
                },
            },
            show = {
                operators = false,
            },
            key_labels = {
                ["<space>"] = "SPC",
                ["<CR>"] = "RET",
                ["<TAB>"] = "TAB",
            },
            icons = {
                breadcrumb = "»",
                separator = "➜",
                group = "+",
                mappings = g.have_nerd_font,
                keys = g.have_nerd_font and {} or {
                },
            },
            win = {
                border = "rounded",
                position = "bottom",
                margin = { 1, 0, 1, 0 },
                padding = { 2, 2, 2, 2 },
                winblend = 0,
            },
            layout = {
                height = { min = 4, max = 25 },
                width = { min = 20, max = 50 },
                spacing = 3,
                align = "left",
            },
            ignore_missing = false,
            filter = function() return true end,
            triggers = { "<leader>" },
            triggers_blacklist = {
                i = { "j", "k" },
                v = { "j", "k" },
            },
            keys = {
                scroll_down = "<C-d>",
                scroll_up = "<C-u>",
            },
        }
        local group_specs = {
            ["<leader>s"] = { name = "[S]earch", mode = "n" },
            ["<leader>t"] = { name = "[T]oggle", mode = "n" },
            ["<leader>h"] = { name = "Git [H]unk", mode = { "n", "v" } },
        }
    end
}
