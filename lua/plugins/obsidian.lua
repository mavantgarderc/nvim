return {
    "epwalsh/obsidian.nvim",
    opts = {
        workspaces = {
            {
                name = "Vanaheim",
                path = "/home/mava/media/data/Obsidian/Vanaheim",
            },
        },
        notes_subdir = "z-Inbox",
        new_notes_location = "z-Inbox",
        ui = {
            enable = false,
        },

        mappings = {
            ["<leader>go"] = {
                action = function() return require("obsidian").util.gf_passthrough() end,
                opts = { noremap = false, expr = true, buffer = true },
            },
        },
    },
}
