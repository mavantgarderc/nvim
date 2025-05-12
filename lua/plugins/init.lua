-- ============================================================================
-- Plugin Management — plugins/init.lua
-- ============================================================================
-- Lazy.nvim bootstrap and plugin registration.
-- ============================================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  print("⏬ Installing Lazy.nvim...")
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath
  })
end

vim.opt.rtp:prepend(lazypath)

-- ============================================================================
-- Plugin Definitions
-- ============================================================================

require("lazy").setup({

  -- Core Enhancements
  { "nvim-lua/plenary.nvim", lazy = true },
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- Mini Icons
  {
    "echasnovski/mini.nvim",
    version = "*",  -- You can specify a version if needed
  },

  -- Fuzzy Finder: Telescope
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function() require("plugins.telescope") end,
  },

  -- Syntax Highlighting & Parsing
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function() require("plugins.treesitter") end,
  },

  -- Git Integration
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    config = function() require("plugins.gitsigns") end,
  },

  -- File Explorer
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = { "MunifTanjim/nui.nvim" },
    config = function() require("plugins.neotree") end,
  },

  -- LSP, Autocompletion, Linting
  { -- LSP Config
    "neovim/nvim-lspconfig",
    config = function() require("core.lsp.init") end,
  },
  { -- Mason
    "williamboman/mason.nvim",
    build = function()
      -- Safe post-install command
      vim.schedule(function()
        vim.cmd("MasonUpdate")
      end)
    end,
    config = function()
      require("mason").setup({
        ui = {
          border = "rounded",
          icons = {
            package_installed = "✔",
            package_pending = "➜",
            package_uninstalled = "✘",
          },
        },
      })
    end,
  },
  { -- Mason LSP Config bridge
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "ts_ls", "pyright", "lua_ls", "clangd", "bashls",
          "html", "cssls", "jsonls", "omnisharp"
        },
        automatic_installation = true,
      })

      -- Load your custom LSP configuration handler
      require("core.lsp.mason")
    end,
  },
  { -- null-ls
    "jose-elias-alvarez/null-ls.nvim",
    config = function() require("core.lsp.null-ls") end,
  },
  { -- LSP Saga
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    config = function()
      require("plugins.lspsaga")
    end,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "nvim-treesitter/nvim-treesitter",
    },
  },
  { -- mason-null-ls
  "jay-babu/mason-null-ls.nvim",
  dependencies = {
    "williamboman/mason.nvim",
    "nvimtools/none-ls.nvim", -- a.k.a. null-ls
  },
  config = function()
    require("mason-null-ls").setup({
      ensure_installed = {
        "black",
        "prettier",
        "stylua",
        "sqlfluff",
        "flake8",
        "eslint_d",
        "shellcheck",
        "markdownlint",
      },
      automatic_installation = true,
      handlers = {}, -- optional custom handlers
    })
  end,
  },

  -- Debugging
  {
    "mfussenegger/nvim-dap",
    config = function() require("plugins.dap") end,
  },

  -- Keymap Discovery
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function() require("plugins.whichkey") end,
  },

  -- UI Enhancements
  {
    "nvim-lualine/lualine.nvim",
    config = function() require("ui.statusline") end,
  },
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd("colorscheme tokyonight-night")
    end,
  },

  -- Session Persistence (Optional Extension)
  {
    "rmagatti/auto-session",
    opts = {},
    cmd = { "SessionSave", "SessionRestore" },
  },

  -- Markdown, Jupyter, Knowledge Tools
  {
    "dccsillag/magma-nvim", -- Jupyter-style cells
    ft = { "python", "r", "julia" },
    build = ":UpdateRemotePlugins",
    config = function() require("plugins.notebook") end,
  },

  -- Snippet Engine
  {
    "L3MON4D3/LuaSnip",
    build = "make install_jsregexp",
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function() require("plugins.snippets") end,
  },

  -- LuaSnip completion source for cmp
  {
    "saadparwaiz1/cmp_luasnip",
    lazy = true,
  },

  -- Completion Engine
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",          -- LSP completion
      "hrsh7th/cmp-buffer",            -- Buffer completion
      "hrsh7th/cmp-path",              -- Filesystem paths
      "hrsh7th/cmp-cmdline",           -- Command-line completion
      "L3MON4D3/LuaSnip",              -- Snippet engine
      "saadparwaiz1/cmp_luasnip",      -- Snippet completions
      "rafamadriz/friendly-snippets", -- Community snippets
    },
    config = function()
      require("plugins.cmp")  -- optional: modular cmp config
    end,
  },

  -- LSP Signature Help completion
  {
    "hrsh7th/cmp-nvim-lsp-signature-help",
    lazy = true,
  },

  -- themes
  {
    {
      "ellisonleao/gruvbox.nvim", priority = 1000 , config = true
    },

  },
})


-- ============================================================================
-- Lazy plugin ecosystem initialized
-- ============================================================================
