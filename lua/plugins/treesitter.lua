return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    lazy = true,
    config = function()
      vim.g.skip_ts_context_commentstring_module = true

      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "lua",
          "vim",
          "vimdoc",
          "bash",
          "python",
          "markdown",
          "markdown_inline",
          "html",
          "css",
          "javascript",
          "typescript",
          "json",
          "yaml",
          "toml",
          "dockerfile",
          "sql",
          "regex",
          "query",
          "latex",
        },
        sync_install = false,
        auto_install = true,
        ignore_install = { "phpdoc" },

        highlight = {
          enable = true,
          disable = { "css" },
          additional_vim_regex_highlighting = { "latex" },
        },

        indent = {
          enable = true,
          disable = { "python", "css", "latex" },
        },

        autopairs = { enable = true },
        incremental_selection = { enable = true },
        textobjects = { enable = true },
      })
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
  },
  {
    "JoosepAlviste/nvim-ts-context-commentstring",
    event = "VeryLazy",
    config = function()
      require("ts_context_commentstring").setup({
        enable_autocmd = false,
        languages = {
          typescript = "// %s",
          javascript = "// %s",
          typescriptreact = { __default = "// %s", jsx = "// %s" },
        },
      })
    end,
  },
}
