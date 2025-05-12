-- ============================================================================
-- Treesitter Configuration — plugins/treesitter.lua
-- ============================================================================
-- Modern parsing engine for syntax, folding, and intelligent navigation
-- ============================================================================
local treeconfig = pcall(require, "nvim-treesitter.configs")
treeconfig.setup({
  -- Languages to ensure are installed
  ensure_installed = {
    "lua", "vim", "vimdoc",
    "c", "cpp", "c_sharp",
    "python", "bash",
    "javascript", "typescript", "tsx", "html", "css",
    "sql", "json", "yaml", "markdown", "markdown_inline",
  },

  -- Sync install flag and auto-installation
  sync_install = false,
  auto_install = true,

  -- Syntax Highlighting
  highlight = {
    enable = true,  -- Enable treesitter highlighting
    additional_vim_regex_highlighting = false,  -- Disable Vim's regex highlighting
  },

  -- Automatic indentation based on syntax
  indent = {
    enable = true,
  },

  -- Incremental selection (select text blocks with keymaps)
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",  -- Start selection
      node_incremental = "grn",  -- Increment node
      scope_incremental = "grc",  -- Increment scope
      node_decremental = "grm",  -- Decrement node
    },
  },

  -- Text Objects: Use treesitter to define text objects like functions and classes
  textobjects = {
    select = {
      enable = true,
      lookahead = true,  -- Move to the next object while selecting
      keymaps = {
        ["af"] = "@function.outer",  -- Select entire function
        ["if"] = "@function.inner",  -- Select inner function
        ["ac"] = "@class.outer",  -- Select entire class
        ["ic"] = "@class.inner",  -- Select inner class
      },
    },
    move = {
      enable = true,
      set_jumps = true,  -- Set jump locations to allow navigation
      goto_next_start = {
        ["]m"] = "@function.outer",  -- Move to next function start
        ["]c"] = "@class.outer",  -- Move to next class start
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",  -- Move to previous function start
        ["[c"] = "@class.outer",  -- Move to previous class start
      },
    },
  },

  -- Folding configuration (optional)
  folding = {
    enable = true,  -- Enable folding using treesitter
    disable = { "yaml", "markdown" },  -- Disable folding for certain languages
  },

  -- Context-aware comment folding (useful for large files)
  context_commentstring = {
    enable = true,
    enable_autocmd = false,  -- Disable autocmd for comment string auto-detection
  },

  -- Additional language parsing features (customizable)
  autotag = {
    enable = true,  -- Enable autotagging for HTML/XML
  },

  -- Ensure additional parser installation for specific languages
  parser_install_dir = vim.fn.stdpath("data") .. "/treesitter_parsers",
})

-- ============================================================================
-- Treesitter initialized
-- ============================================================================