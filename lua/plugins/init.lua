return{
  -- === ui ===
  -- status line
  "nvim-lualine/lualine.nvim",
  -- dashboard
  "goolord/alpha-nvim",
  -- themes
  {
    "catppuccin/nvim",
    "folke/tokyonight.nvim",
    "ellisonleao/gruvbox.nvim",
    "ellisonleao/gruvbox.nvim",
    "rose-pine/neovim",
    "navarasu/onedark.nvim",
    "EdenEast/nightfox.nvim",
    "themercorp/themer.lua",
    'shaunsingh/nord.nvim',
    "MordechaiHadad/nvim-papadark",
    "Mofiqul/dracula.nvim",
    "NTBBloodbath/doom-one.nvim",
    "neanias/everforest-nvim",
    "marko-cerovac/material.nvim",
    "rebelot/kanagawa.nvim",
    "nyoom-engineering/oxocarbon.nvim",
  },
  -- ==================================================
  -- === LSP ===
  {
  "VonHeikemen/lsp-zero.nvim",
  dependencies = {
      -- LSP Support
      "neovim/nvim-lspconfig",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      -- Autocompletion
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp_luasnip",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "saadparwaiz1/cmp_luasnip",
      -- Snippets
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
  }},
  -- ==================================================
  -- === nvim plugins ===
  -- filetree
  "MunifTanjim/nui.nvim",
  "nvim-treesitter/nvim-treesitter",
  "nvim-treesitter/playground",
  -- telescope
  "nvim-telescope/telescope.nvim",
  "nvim-telescope/telescope-ui-select.nvim",
  -- harpoon
  "ThePrimeagen/harpoon",
  -- undotree
  "mbbill/undotree",
  -- fugitive (git integration)
  "tpope/vim-fugitive",
  -- tmux integration
  "christoomey/vim-tmux-navigator",
}
