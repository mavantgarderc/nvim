return{
  -- ui
  -- status line
  "nvim-lualine/lualine.nvim",
  -- dashboard
  "goolord/alpha-nvim",
  -- themes
  "catppuccin/nvim",
  "folke/tokyonight.nvim",
  "ellisonleao/gruvbox.nvim",
  {
    "rose-pine/neovim",
    as = "rose-pine",
    config = function()
      vim.cmd("colorscheme rose-pine")
    end
  },
  "navarasu/onedark.nvim",
  "EdenEast/nightfox.nvim",

  -- ==================================================

  -- mason, lsp, null-ls
  -- mason
  "mason-org/mason.nvim",
  -- mason-lsp
  "mason-org/mason-lspconfig.nvim",
  -- nvim-lsp
  "neovim/nvim-lspconfig",
  -- none-ls
  "nvimtools/none-ls.nvim",

  -- ==================================================

  -- nvim plugins

  -- filetree
  "MunifTanjim/nui.nvim",
  "nvim-treesitter/nvim-treesitter",
  "nvim-treesitter/playground",
  -- "nvim-neo-tree/neo-tree.nvim",
  -- telescope
  "nvim-telescope/telescope.nvim",
  "nvim-telescope/telescope-ui-select.nvim",
  -- harpoon
  "ThePrimeagen/harpoon",
  -- undotree
  "mbbill/undotree",
  -- fugitive
  "tpope/vim-fugitive",
}
