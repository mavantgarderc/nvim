return {
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.5",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-ui-select.nvim",
        },
        config = function()
            local telescope = require("telescope")
            local builtin = require("telescope.builtin")
            local map = vim.keymap.set
            local fn = vim.fn

            telescope.setup({
                extensions = {
                    ["ui-select"] = require("telescope.themes").get_dropdown(),
                },
            })

            -- Load extension
            telescope.load_extension("ui-select")

            -- Keymaps
            map("n", "<leader>pf", builtin.find_files, { desc = "[P]roject [F]iles" })
            map("n", "<C-p>", builtin.git_files, { desc = "[G]it [F]iles" })

            map("n", "<leader>ps", function()
                builtin.grep_string({ search = fn.input("Grep > ") })
            end, { desc = "[P]roject [S]earch string" })

            -- Optional extra keymaps (uncomment to enable)
            -- map("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
            -- map("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
            -- map("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
            -- map("n", "<leader>ss", builtin.builtin, { desc = "[S]elect [S]ource" })
            -- map("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
            -- map("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
            -- map("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
            -- map("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
            -- map("n", "<leader>s.", builtin.oldfiles, { desc = "[S]earch Recent Files" })
            map("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })
            map("n", "<leader><leader>", "<cmd>Telescope buffers sort_mru=lastused=true initial_mode=normal<CR>", opts)

            -- Current buffer fuzzy find (dropdown)
            map("n", "<leader>/", function()
              builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
                winblend = 10,
                previewer = false,
              }))
            end, { desc = "[/] Search in buffer" })

            -- Live grep only in open files
            map("n", "<leader>s/", function()
              builtin.live_grep({
                grep_open_files = true,
                prompt_title = "live grep in open files",
              })
            end, { desc = "[s]earch [/] in open files" })

            -- Search Neovim config files
            map("n", "<leader>sn", function()
              builtin.find_files({ cwd = fn.stdpath("config") })
            end, { desc = "[S]earch [N]eovim files" })
        end,
    },
}
