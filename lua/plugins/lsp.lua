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
      local orig_notify = vim.notify
      vim.notify = function(msg, level, opts)
        if msg:match("The `require%('lspconfig'%)` \"framework\" is deprecated") then return end
        orig_notify(msg, level, opts)
      end
      require("lspconfig")
      local lsp = require("lsp-zero").preset({})
      require("mason").setup()

      local shared_config = require("lsp.shared")
      lsp.on_attach(function(_, bufnr) lsp.default_keymaps({ buffer = bufnr }) end)
      shared_config.setup_keymaps()
      shared_config.setup_diagnostics()
      shared_config.setup_null_ls()
      shared_config.setup_format_keymap()

      local capabilities = shared_config.get_capabilities()

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
          "gopls",
          "rust_analyzer",
          "zls",
          "graphql",
          "yamlls",
          "marksman",
          "vimls",
        },
        automatic_installation = true,
        handlers = {
          function(server_name)
            local ok, custom = pcall(require, "lsp.servers." .. server_name)
            if ok and type(custom.setup) == "function" then
              custom.setup(capabilities)
            else
              local ok_lsp, lspconfig = pcall(require, "lspconfig")
              if ok_lsp and lspconfig[server_name] then
                lspconfig[server_name].setup({ capabilities = capabilities })
              else
                vim.notify("[lsp] could not configure " .. server_name, vim.log.levels.WARN)
              end
            end
          end,
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

      lsp.setup()
    end,
  },
}
