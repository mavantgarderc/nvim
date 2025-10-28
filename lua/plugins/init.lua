return {
  -- ==================================================
  -- === ui ===
  -- Oil file explorer
  "stevearc/oil.nvim",
  -- status line & tabbar
  "nvim-lualine/lualine.nvim",
  -- startup dashboard
  "goolord/alpha-nvim",
  -- text coloring
  "echasnovski/mini.hipatterns",
  -- themes
  "RRethy/base16-nvim",
  "catppuccin/nvim",
  "folke/tokyonight.nvim",
  "ellisonleao/gruvbox.nvim",
  "EdenEast/nightfox.nvim",
  "rebelot/kanagawa.nvim",
  "thesimonho/kanagawa-paper.nvim",
  "nyoom-engineering/oxocarbon.nvim",
  "whatyouhide/vim-gotham",
  "everviolet/nvim",
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
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "saadparwaiz1/cmp_luasnip",
      {
        "Hoffs/omnisharp-extended-lsp.nvim",
        lazy = true,
      },
      -- Dev Enhancements
      {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
          library = {
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
      -- dadbod
      "tpope/vim-dadbod",
      "kristijanhusak/vim-dadbod-completion",
      "kristijanhusak/vim-dadbod-ui",
      "tpope/vim-dotenv",
      "nanotee/sqls.nvim",
      -- Utilities
      -- indent automation; no config needed
      "NMAC427/guess-indent.nvim",
      -- Snippets
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
      --
      "j-hui/fidget.nvim",
      --
      "stevearc/conform.nvim",
    },
  },
  -- Pair Character Completion
  "windwp/nvim-autopairs",
  -- ==================================================
  -- === Obsidian Integration ===
  {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = true,
    ft = "markdown",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
  -- ==================================================
  -- === LaTeX Integration ===
  "lervag/vimtex",
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
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
      { "nvim-telescope/telescope-ui-select.nvim" },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
    },
  },
  -- undotree
  "mbbill/undotree",
  -- terminal multiplexer navigations
  "christoomey/vim-tmux-navigator",
  "swaits/zellij-nav.nvim",
  -- ==================================================
  -- Git Integration
  "lewis6991/gitsigns.nvim",
  -- ==================================================
  -- keymaps of vscode
  "mg979/vim-visual-multi",
  -- Flash
  "folke/flash.nvim",
}
