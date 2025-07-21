return {
    -- ==================================================
    -- Oil file explorer
    "stevearc/oil.nvim",
    -- === Optimizer
    "lewis6991/impatient.nvim",
    -- === ui ===
    -- status line & tabbar
    "nvim-lualine/lualine.nvim",
    -- startup dashboard
    "goolord/alpha-nvim",
    -- Colorizer
    "norcalli/nvim-colorizer.lua",
    -- themes
    {
        "RRethy/base16-nvim",
        "catppuccin/nvim",
        "folke/tokyonight.nvim",
        "ellisonleao/gruvbox.nvim",
        "EdenEast/nightfox.nvim",
        "rebelot/kanagawa.nvim",
        "thesimonho/kanagawa-paper.nvim",
        "nyoom-engineering/oxocarbon.nvim",
        "whatyouhide/vim-gotham",
    },
    -- ==================================================
    -- === LSP ===
    {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v3.x",
        dependencies = {
            -- LSP Core
            "neovim/nvim-lspconfig",
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            -- Autocompletion Core
            "hrsh7th/nvim-cmp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp_luasnip",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-nvim-lua",
            "saadparwaiz1/cmp_luasnip",
            -- Dev Enhancements
            {
                "folke/lazydev.nvim",
                ft = "lua",
                opt = {
                    library = {
                        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                    },
                },
            },
            -- Utilities
            -- indent automation; no config needed
            "NMAC427/guess-indent.nvim",
            -- Snippets
            "L3MON4D3/LuaSnip",
            "rafamadriz/friendly-snippets",
        },
    },
    -- Pair Character Completion
    "windwp/nvim-autopairs",
    -- ==================================================
    -- -- === Obsidian Integration ===
    {
        "epwalsh/obsidian.nvim",
        version = "*",
        lazy = true,
        ft = "markdown",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
    },
    {
        "renerocksai/telekasten.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
    },
    -- ==================================================
    -- === nvim plugins ===
    -- filetree
    "MunifTanjim/nui.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-treesitter/playground",
    -- telescope
    {
        "nvim-telescope/telescope.nvim",
        event = "VimEnter",
        dependencies = {
            "nvim-lua/plenary.nvim",
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
                cond = function() return vim.fn.executable("make") == 1 end,
            },
            { "nvim-telescope/telescope-ui-select.nvim" },

            -- Useful for getting pretty icons, but requires a Nerd Font.
            { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
        },
    },
    -- harpoon
    "ThePrimeagen/harpoon",
    -- undotree
    "mbbill/undotree",
    -- terminal multiplexer navigations
    "christoomey/vim-tmux-navigator",
    "swaits/zellij-nav.nvim",
    -- ==================================================
    -- Git Integration
    "lewis6991/gitsigns.nvim",
    -- ==================================================
    -- which-key; to show pending keybinds
    "folke/which-key.nvim",
    -- nice-ass comments
    {
        "folke/todo-comments.nvim",
        event = "VimEnter",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        opts = { signs = false },
    },
    -- keymaps of vscode
    "mg979/vim-visual-multi",
    -- Flash
    "folke/flash.nvim",
}
