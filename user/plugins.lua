require('lazy').setup {
  -- File explorer
  { 'nvim-tree/nvim-tree.lua', dependencies = { 'nvim-tree/nvim-web-devicons' } },

  -- Fuzzy finder
  { 'nvim-telescope/telescope.nvim', dependencies = { 'nvim-lua/plenary.nvim' } },

  -- Colorscheme
  { 'catppuccin/nvim', name = 'catppuccin', priority = 1000 },

  -- LSP and Autocompletion
  { 'neovim/nvim-lspconfig' },
  { 'hrsh7th/nvim-cmp' },
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'L3MON4D3/LuaSnip' },

  -- Git
  { 'lewis6991/gitsigns.nvim' },

  -- Status line
  { 'nvim-lualine/lualine.nvim' },
}

-- Load and configure plugins
require('nvim-tree').setup()
require('gitsigns').setup()
require('lualine').setup { options = { theme = 'catppuccin' } }
vim.cmd.colorscheme 'catppuccin'
