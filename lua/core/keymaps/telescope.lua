local fn = vim.fn
local map = vim.keymap.set
local api = vim.api

api.nvim_create_autocmd("User", {
    pattern = "LazyLoad",
    callback = function(event)
        if event.data == "telescope.nvim" then
            local builtin = require('telescope.builtin')
            -- File pickers
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

        end
    end,
})
