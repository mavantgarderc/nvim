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
            local actions = require("telescope.actions")
            local map = vim.keymap.set
            local fn = vim.fn

            telescope.setup({
                defaults = {
                    prompt_prefix = " ",
                    selection_caret = " ",
                    path_display = { "smart" },
                    mappings = {
                        i = {
                            ["<C-n>"] = actions.cycle_history_next,
                            ["<C-p>"] = actions.cycle_history_prev,
                            ["<C-j>"] = actions.move_selection_next,
                            ["<C-k>"] = actions.move_selection_previous,
                            ["<C-c>"] = actions.close,
                            ["<Down>"] = actions.move_selection_next,
                            ["<Up>"] = actions.move_selection_previous,
                            ["<CR>"] = actions.select_default,
                            ["<C-x>"] = actions.select_horizontal,
                            ["<C-v>"] = actions.select_vertical,
                            ["<C-t>"] = actions.select_tab,
                            ["<C-u>"] = actions.preview_scrolling_up,
                            ["<C-d>"] = actions.preview_scrolling_down,
                            ["<PageUp>"] = actions.results_scrolling_up,
                            ["<PageDown>"] = actions.results_scrolling_down,
                            ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
                            ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
                            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
                            ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                            ["<C-l>"] = actions.complete_tag,
                            ["<C-_>"] = actions.which_key,
                        },
                        n = {
                            ["<esc>"] = actions.close,
                            ["<CR>"] = actions.select_default,
                            ["<C-x>"] = actions.select_horizontal,
                            ["<C-v>"] = actions.select_vertical,
                            ["<C-t>"] = actions.select_tab,
                            ["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
                            ["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
                            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
                            ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
                            ["j"] = actions.move_selection_next,
                            ["k"] = actions.move_selection_previous,
                            ["H"] = actions.move_to_top,
                            ["M"] = actions.move_to_middle,
                            ["L"] = actions.move_to_bottom,
                            ["<Down>"] = actions.move_selection_next,
                            ["<Up>"] = actions.move_selection_previous,
                            ["gg"] = actions.move_to_top,
                            ["G"] = actions.move_to_bottom,
                            ["<C-u>"] = actions.preview_scrolling_up,
                            ["<C-d>"] = actions.preview_scrolling_down,
                            ["<PageUp>"] = actions.results_scrolling_up,
                            ["<PageDown>"] = actions.results_scrolling_down,
                            ["?"] = actions.which_key,
                        },
                    },
                },
                pickers = {
                    buffers = {
                        sort_mru = true,
                        sort_lastused = true,
                        initial_mode = "normal",
                    },
                    -- Add other picker customizations here
                },
                extensions = {
                    ["ui-select"] = require("telescope.themes").get_dropdown(),
                },
            })

            -- Load extensions
            telescope.load_extension("ui-select")

            -- Keymaps
            local keymap_opts = { noremap = true, silent = true }

            map("n", "<leader>pf", builtin.find_files, { desc = "[P]roject [F]iles" })
            map("n", "<C-p>", builtin.git_files, { desc = "[G]it [F]iles" })

            map(
                "n",
                "<leader>ps",
                function() builtin.grep_string({ search = fn.input("Grep > ") }) end,
                { desc = "[P]roject [S]earch string" }
            )

            map(
                "n",
                "<leader><leader>",
                function()
                    builtin.buffers({
                        sort_mru = true,
                        sort_lastused = true,
                        initial_mode = "normal",
                    })
                end,
                { desc = "[ ] Find existing buffers" }
            )

            map(
                "n",
                "<leader>/",
                function()
                    builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
                        winblend = 10,
                        previewer = false,
                    }))
                end,
                { desc = "[/] Search in buffer" }
            )

            map(
                "n",
                "<leader>s/",
                function()
                    builtin.live_grep({
                        prompt_title = "Live Grep in Open Files",
                    })
                end,
                { desc = "[S]earch [/] in open files" }
            )

            map(
                "n",
                "<leader>sn",
                function() builtin.find_files({ cwd = fn.stdpath("config") }) end,
                { desc = "[S]earch [N]eovim files" }
            )

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
        end,
    },
}
