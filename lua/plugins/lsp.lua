return {
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v3.x",
    dependencies = {
      "neovim/nvim-lspconfig",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
      "nvimtools/none-ls.nvim",
    },

    config = function()
      local lsp = require("lsp-zero").preset({})
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local diagnostic = vim.diagnostic
      local g = vim.g
      local map = vim.keymap.set
      local api = vim.api
      local buf = vim.lsp.buf
      vim.opt.signcolumn = "yes"

      require("mason").setup()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "ts_ls",
          "pyright",
          "omnisharp",
          "html",
          "cssls",
          "texlab",
          "sqls",
          "solidity_ls",
          "dockerls",
          "jsonls",
        },
        automatic_installation = true,
        handlers = {
          lsp.default_setup,
        },
      })

      local mason_tool_installer = require("mason-tool-installer")
      mason_tool_installer.setup({
        ensure_installed = {
          "stylua",
          "csharpier",
          "sql-formatter",
          "sqlfluff",
        },
        auto_update = false,
        run_on_start = true,
      })

      local shared_config = require("lsp.shared")

      lsp.on_attach(function(_, bufnr)
        lsp.default_keymaps({ buffer = bufnr })
      end)

      shared_config.setup_keymaps()

      shared_config.setup_diagnostics()

      shared_config.setup_completion(cmp, luasnip)

      local capabilities = shared_config.get_capabilities()

      require("lsp.servers.lua_ls").setup(capabilities)
      require("lsp.servers.typescript").setup(capabilities)
      require("lsp.servers.python").setup(capabilities)
      require("lsp.servers.omnisharp").setup(capabilities)
      require("lsp.servers.html").setup(capabilities)
      require("lsp.servers.css").setup(capabilities)
      require("lsp.servers.latex").setup(capabilities)
      require("lsp.servers.sql").setup(capabilities)
      require("lsp.servers.solidity").setup()

      shared_config.setup_null_ls()

      shared_config.setup_format_keymap()

      lsp.setup()
    end,
  },
}
