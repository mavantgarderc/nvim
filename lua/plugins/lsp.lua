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

    event = { "BufReadPre", "BufNewFile" },

    config = function()
      local orig_notify = vim.notify
      vim.notify = function(msg, level, opts)
        if msg:match("The `require%('lspconfig'%)` \"framework\" is deprecated") then
          return
        end
        orig_notify(msg, level, opts)
      end

      local ok, _ = pcall(require, "lspconfig")
      if not ok then
        vim.notify("[plugins.lsp] nvim-lspconfig failed to load", vim.log.levels.ERROR)
        return
      end

      local lsp = require("lsp-zero").preset({})
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
      shared_config.setup_null_ls()
      shared_config.setup_format_keymap()

      lsp.setup()

      local capabilities = shared_config.get_capabilities()

      local ok_lua, lua_ls = pcall(require, "lsp.servers.lua_ls")
      if ok_lua and type(lua_ls.setup) == "function" then
        lua_ls.setup(capabilities)
      else
        vim.notify("[LSP] lua_ls setup skipped (not found)", vim.log.levels.WARN)
      end

      local servers = {
        "typescript",
        "python",
        "omnisharp",
        "html",
        "css",
        "latex",
        "sql",
        "solidity",
      }

      for _, name in ipairs(servers) do
        local ok, mod = pcall(require, "lsp.servers." .. name)
        if ok and type(mod.setup) == "function" then
          mod.setup(capabilities)
        else
          vim.notify(string.format("[LSP] %s setup skipped (not found)", name), vim.log.levels.WARN)
        end
      end
    end,
  },
}
