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
                    prompt_prefix = "   ",
                    selection_caret = "   ",
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
                },
                extensions = {
                    ["ui-select"] = require("telescope.themes").get_dropdown(),
                },
            })

            telescope.load_extension("ui-select")

            map('n', '<leader>ff', builtin.find_files, { desc = 'Find files' })
            map('n', '<leader>fg', builtin.live_grep, { desc = 'Live grep' })
            map('n', '<leader>fb', builtin.buffers, { desc = 'Find buffers' })
            map('n', '<leader>fh', builtin.help_tags, { desc = 'Help tags' })
            map('n', '<leader>fr', builtin.oldfiles, { desc = 'Recent files' })
            map('n', '<leader>fc', builtin.colorscheme, { desc = 'Colorschemes' })

            -- Search
            map('n', '<leader>fw', builtin.grep_string, { desc = 'Find word under cursor' })
            map( "n", "<leader>/", function()
                builtin.current_buffer_fuzzy_find (require("telescope.themes").get_dropdown({ winblend = 10, previewer = false, }))
            end, { desc = "[/] Search in buffer" })

            -- Git
            map('n', '<leader>gc', builtin.git_commits, { desc = 'Git commits' })
            map('n', '<leader>gb', builtin.git_branches, { desc = 'Git branches' })
            map('n', '<leader>gs', builtin.git_status, { desc = 'Git status' })
            map('n', '<leader>gf', builtin.git_files, { desc = 'Git files' })

            -- LSP
            map('n', '<leader>lr', builtin.lsp_references, { desc = 'LSP references' })
            map('n', '<leader>ld', builtin.lsp_definitions, { desc = 'LSP definitions' })
            map('n', '<leader>li', builtin.lsp_implementations, { desc = 'LSP implementations' })
            map('n', '<leader>lt', builtin.lsp_type_definitions, { desc = 'LSP type definitions' })
            map('n', '<leader>ls', builtin.lsp_document_symbols, { desc = 'Document symbols' })
            map('n', '<leader>lw', builtin.lsp_workspace_symbols, { desc = 'Workspace symbols' })
            map('n', '<leader>le', builtin.diagnostics, { desc = 'Diagnostics' })

            -- Vim pickers
            map('n', '<leader>fk', builtin.keymaps, { desc = 'Find keymaps' })
            map('n', '<leader>fo', builtin.vim_options, { desc = 'Vim options' })
            map('n', '<leader>ft', builtin.filetypes, { desc = 'File types' })
            map('n', '<leader>fq', builtin.quickfix, { desc = 'Quickfix list' })
            map('n', '<leader>fl', builtin.loclist, { desc = 'Location list' })
            map('n', '<leader>fj', builtin.jumplist, { desc = 'Jump list' })
            map('n', '<leader>fm', builtin.marks, { desc = 'Marks' })
            map('n', '<leader>fa', builtin.autocommands, { desc = 'Autocommands' })
            map('n', '<leader>fz', builtin.spell_suggest, { desc = 'Spell suggestions' })

            -- Advanced searches
            map('n', '<leader>f/', builtin.search_history, { desc = 'Search history' })
            map('n', '<leader>f:', builtin.command_history, { desc = 'Command history' })
            map('n', '<leader>f"', builtin.registers, { desc = 'Registers' })

            -- Resume last picker
            map( "n", "<leader><leader>", function()
                builtin.buffers({
                    sort_mru = true,
                    sort_lastused = true,
                    initial_mode = "normal", })
            end, { desc = "[ ] Find existing buffers" })

            -- Custom functions with options
            map('n', '<leader>fF', function()
                builtin.find_files({ hidden = true })
            end, { desc = 'Find files (including hidden)' })

            map('n', '<leader>fG', function()
                builtin.live_grep({ additional_args = { "--hidden" } })
            end, { desc = 'Live grep (including hidden)' })

            map('n', '<leader>fd', function()
                builtin.find_files({ cwd = fn.expand('%:p:h') })
            end, { desc = 'Find files in current directory' })

            map('n', '<leader>fD', function()
                builtin.live_grep({ cwd = fn.expand('%:p:h') })
            end, { desc = 'Live grep in current directory' })

            map( "n", "<leader>s/", function()
                builtin.live_grep({ prompt_title = "Live Grep in Open Files", })
            end, { desc = "[S]earch [/] in open files" })

            map( "n", "<leader>sn", function()
                builtin.find_files({ cwd = fn.stdpath("config") })
            end, { desc = "[S]earch [N]eovim files" })

            -- Config files
            map('n', '<leader>fn', function()
                builtin.find_files({ cwd = fn.stdpath('config') })
            end, { desc = 'Find nvim config files' })

            -- Dotfiles (adjust path as needed)
            map('n', '<leader>f.', function()
                builtin.find_files({ cwd = '~/dotfiles' })
            end, { desc = 'Find dotfiles' })

            -- Projects (if you have a projects directory)
            map('n', '<leader>fp', function()
                builtin.find_files({ cwd = '~/projects' })
            end, { desc = 'Find project files' })

            -- Visual mode search
            map('v', '<leader>fg', function()
                builtin.grep_string({ default_text = fn.expand('<cword>') })
            end, { desc = 'Grep selection' })

        end,
    },
}
