return {
    "folke/which-key.nvim",
    event = "VimEnter",
    config = function()
        local status_ok, which_key = pcall(require, "which-key")
        if not status_ok then return end

        -- Updated configuration without deprecated options
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
                operators = false, -- Replaces hidden
            },
            key_labels = {
                -- Preserve your custom key labels
                ["<space>"] = "SPC",
                ["<cr>"] = "RET",
                ["<tab>"] = "TAB",
            },
            icons = {
                breadcrumb = "»",
                separator = "➜",
                group = "+",
                mappings = vim.g.have_nerd_font,
                keys = vim.g.have_nerd_font and {} or {
                    -- Your custom key icons...
                },
            },
            win = { -- Replaces window
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
            ignore_missing = false, -- Replaced by filter
            filter = function() return true end, -- Custom filter if needed
            triggers = { "<leader>" }, -- Must be table
            triggers_blacklist = { -- Keep as is
                i = { "j", "k" },
                v = { "j", "k" },
            },
            keys = { -- Replaces popup_mappings
                scroll_down = "<c-d>",
                scroll_up = "<c-u>",
            },
        }

        -- New-style group specifications
        local group_specs = {
            ["<leader>s"] = { name = "[S]earch", mode = "n" },
            ["<leader>t"] = { name = "[T]oggle", mode = "n" },
            ["<leader>h"] = { name = "Git [H]unk", mode = { "n", "v" } },
        }
    end
}

        -- Convert mappings to new flat spec
--        local flat_mappings = {
--            -- Single-key mappings
--            {
--                "<leader>a",
--                "<cmd>Alpha<cr>",
--                desc = "Alpha",
--            },
--            {
--                "<leader>b",
--                "<cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown{previewer = false})<cr>",
--                desc = "Buffers",
--            },
--            {
--                "<leader>e",
--                "<cmd>NvimTreeToggle<cr>",
--                desc = "Explorer",
--            },
--            {
--                "<leader>w",
--                "<cmd>w!<CR>",
--                desc = "Save",
--            },
--            {
--                "<leader>q",
--                "<cmd>q!<CR>",
--                desc = "Quit",
--            },
--            {
--                "<leader>c",
--                "<cmd>Bdelete!<CR>",
--                desc = "Close Buffer",
--            },
--            {
--                "<leader>f",
--                "<cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown{previewer = false})<cr>",
--                desc = "Find files",
--            },
--            {
--                "<leader>F",
--                "<cmd>Telescope live_grep theme=ivy<cr>",
--                desc = "Find Text",
--            },
--            {
--                "<leader>P",
--                "<cmd>lua require('telescope').extensions.projects.projects()<cr>",
--                desc = "Projects",
--            },
--
--            -- Packer
--            {
--                "<leader>pc",
--                "<cmd>PackerCompile<cr>",
--                desc = "Compile",
--            },
--            {
--                "<leader>pi",
--                "<cmd>PackerInstall<cr>",
--                desc = "Install",
--            },
--            {
--                "<leader>ps",
--                "<cmd>PackerSync<cr>",
--                desc = "Sync",
--            },
--            {
--                "<leader>pS",
--                "<cmd>PackerStatus<cr>",
--                desc = "Status",
--            },
--            {
--                "<leader>pu",
--                "<cmd>PackerUpdate<cr>",
--                desc = "Update",
--            },
--
--            -- Git (resolving overlap)
--            {
--                "<leader>gg",
--                "<cmd>lua _LAZYGIT_TOGGLE()<CR>",
--                desc = "Lazygit",
--            },
--            {
--                "<leader>gj",
--                "<cmd>lua require 'gitsigns'.next_hunk()<cr>",
--                desc = "Next Hunk",
--            },
--            {
--                "<leader>gk",
--                "<cmd>lua require 'gitsigns'.prev_hunk()<cr>",
--                desc = "Prev Hunk",
--            },
--            {
--                "<leader>gl",
--                "<cmd>lua require 'gitsigns'.blame_line()<cr>",
--                desc = "Blame",
--            },
--            {
--                "<leader>gp",
--                "<cmd>lua require 'gitsigns'.preview_hunk()<cr>",
--                desc = "Preview Hunk",
--            },
--            {
--                "<leader>gr",
--                "<cmd>lua require 'gitsigns'.reset_hunk()<cr>",
--                desc = "Reset Hunk",
--            },
--            {
--                "<leader>gR",
--                "<cmd>lua require 'gitsigns'.reset_buffer()<cr>",
--                desc = "Reset Buffer",
--            },
--            {
--                "<leader>gs",
--                "<cmd>lua require 'gitsigns'.stage_hunk()<cr>",
--                desc = "Stage Hunk",
--            },
--            {
--                "<leader>gu",
--                "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",
--                desc = "Undo Stage Hunk",
--            },
--            {
--                "<leader>go",
--                "<cmd>Telescope git_status<cr>",
--                desc = "Open changed file",
--            },
--            {
--                "<leader>gb",
--                "<cmd>Telescope git_branches<cr>",
--                desc = "Checkout branch",
--            },
--            {
--                "<leader>gc",
--                "<cmd>Telescope git_commits<cr>",
--                desc = "Checkout commit",
--            },
--            {
--                "<leader>gd",
--                "<cmd>Gitsigns diffthis HEAD<cr>",
--                desc = "Diff",
--            },
--
--            -- LSP (resolving overlap)
--            {
--                "<leader>la",
--                "<cmd>lua vim.lsp.buf.code_action()<cr>",
--                desc = "Code Action",
--            },
--            {
--                "<leader>ld",
--                "<cmd>Telescope diagnostics bufnr=0<cr>",
--                desc = "Document Diagnostics",
--            },
--            {
--                "<leader>lw",
--                "<cmd>Telescope diagnostics<cr>",
--                desc = "Workspace Diagnostics",
--            },
--            {
--                "<leader>lf",
--                "<cmd>lua vim.lsp.buf.format{async=true}<cr>",
--                desc = "Format",
--            },
--            {
--                "<leader>li",
--                "<cmd>LspInfo<cr>",
--                desc = "Info",
--            },
--            {
--                "<leader>lI",
--                "<cmd>LspInstallInfo<cr>",
--                desc = "Installer Info",
--            },
--            {
--                "<leader>lj",
--                "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>",
--                desc = "Next Diagnostic",
--            },
--            {
--                "<leader>lk",
--                "<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>",
--                desc = "Prev Diagnostic",
--            },
--            {
--                "<leader>ll",
--                "<cmd>lua vim.lsp.codelens.run()<cr>",
--                desc = "CodeLens Action",
--            },
--            {
--                "<leader>lq",
--                "<cmd>lua vim.diagnostic.setloclist()<cr>",
--                desc = "Quickfix",
--            },
--            {
--                "<leader>lr",
--                "<cmd>lua vim.lsp.buf.rename()<cr>",
--                desc = "Rename",
--            },
--            {
--                "<leader>ls",
--                "<cmd>Telescope lsp_document_symbols<cr>",
--                desc = "Document Symbols",
--            },
--            {
--                "<leader>lS",
--                "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
--                desc = "Workspace Symbols",
--            },
--
--            -- Search (resolving overlap)
--            {
--                "<leader>sb",
--                "<cmd>Telescope git_branches<cr>",
--                desc = "Checkout branch",
--            },
--            {
--                "<leader>sc",
--                "<cmd>Telescope colorscheme<cr>",
--                desc = "Colorscheme",
--            },
--            {
--                "<leader>sh",
--                "<cmd>Telescope help_tags<cr>",
--                desc = "Find Help",
--            },
--            {
--                "<leader>sM",
--                "<cmd>Telescope man_pages<cr>",
--                desc = "Man Pages",
--            },
--            {
--                "<leader>sr",
--                "<cmd>Telescope oldfiles<cr>",
--                desc = "Open Recent File",
--            },
--            {
--                "<leader>sR",
--                "<cmd>Telescope registers<cr>",
--                desc = "Registers",
--            },
--            {
--                "<leader>sk",
--                "<cmd>Telescope keymaps<cr>",
--                desc = "Keymaps",
--            },
--            {
--                "<leader>sC",
--                "<cmd>Telescope commands<cr>",
--                desc = "Commands",
--            },
--
--            -- Terminal
--            {
--                "<leader>tn",
--                "<cmd>lua _NODE_TOGGLE()<cr>",
--                desc = "Node",
--            },
--            {
--                "<leader>tu",
--                "<cmd>lua _NCDU_TOGGLE()<cr>",
--                desc = "NCDU",
--            },
--            {
--                "<leader>tt",
--                "<cmd>lua _HTOP_TOGGLE()<cr>",
--                desc = "Htop",
--            },
--            {
--                "<leader>tp",
--                "<cmd>lua _PYTHON_TOGGLE()<cr>",
--                desc = "Python",
--            },
--            {
--                "<leader>tf",
--                "<cmd>ToggleTerm direction=float<cr>",
--                desc = "Float",
--            },
--            {
--                "<leader>th",
--                "<cmd>ToggleTerm size=10 direction=horizontal<cr>",
--                desc = "Horizontal",
--            },
--            {
--                "<leader>tv",
--                "<cmd>ToggleTerm size=80 direction=vertical<cr>",
--                desc = "Vertical",
--            },
--
--            -- Additional mappings to resolve conflicts
--            {
--                "<leader>hn",
--                "<cmd>nohlsearch<CR>",
--                desc = "No Highlight",
--            }, -- Moved from <leader>h
--        }
--
--        -- Register everything
--        which_key.setup(setup)
--
--        -- Register group specifications
--        for key, spec in pairs(group_specs) do
--            which_key.register({ [key] = spec })
--        end
--
--        -- Register flat mappings
--        which_key.register(flat_mappings, {
--            mode = "n",
--            silent = true,
--            noremap = true,
--            nowait = true,
--        })
--
--        -- Additional registration for visual mode Git hunks
--        which_key.register({
--            ["<leader>h"] = { name = "Git [H]unk" },
--            ["<leader>hs"] = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
--            ["<leader>hr"] = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
--        }, { mode = "v" })
--    end,

