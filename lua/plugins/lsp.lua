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
      "j-hui/fidget.nvim",
      "stevearc/conform.nvim",
      "aznhe21/actions-preview.nvim",
      "andythigpen/nvim-coverage",
    },
    config = function()
      local orig_notify = vim.notify
      vim.notify = function(msg, level, opts)
        if msg:match("The `require%('lspconfig'%)` \"framework\" is deprecated") then
          return
        end
        orig_notify(msg, level, opts)
      end

      require("lspconfig")
      local lsp = require("lsp-zero").preset({})
      vim.opt.signcolumn = "yes"

      require("mason").setup()

      local shared_config = require("lsp.shared")

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev)
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          if client and client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
          end

          lsp.default_keymaps({ buffer = ev.buf })
        end,
      })

      shared_config.setup_keymaps()
      shared_config.setup_diagnostics()
      shared_config.setup_conform()
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
          "bashls",
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
          "prettier",
          "black",
          "isort",
          "goimports",
          "gofumpt",
          "shfmt",
          "autopep8",
          "eslint_d",
          "terraform-ls",
          "tflint",
          "clang-format",
        },
        auto_update = false,
        run_on_start = true,
      })

      lsp.setup()

      local ok, auto_install = pcall(require, "lsp.auto-install")
      if ok and type(auto_install.check_and_prompt) == "function" then
        auto_install.check_and_prompt()
      end

      local border = "rounded"
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border })
      vim.lsp.handlers["textDocument/signatureHelp"] =
        vim.lsp.with(vim.lsp.handlers.signature_help, { border = border })
      vim.diagnostic.config({
        float = { border = border },
      })

      local lsp_keymap_ok, keymaps = pcall(require, "core.keymaps.lsp")
      if lsp_keymap_ok and type(keymaps.setup) == "function" then
        keymaps.setup()
      end

      vim.api.nvim_create_autocmd("BufWritePost", {
        pattern = { "*/lsp/*.lua", "*/plugins/lsp.lua" },
        callback = function()
          vim.notify("LSP config changed, restart with :LspRestart", vim.log.levels.INFO)
        end,
      })

      -- UNCOMMENT ME WHEN YOU NEED TO HEALTCHCHECK THE LSP CLIENTS/SERVERS
      -- vim.api.nvim_create_autocmd("VimEnter", {
      --   once = true,
      --   callback = function()
      --     vim.defer_fn(function()
      --       local health_ok = pcall(vim.cmd, "silent checkhealth lsp")
      --       if not health_ok then vim.notify("LSP health check failed", vim.log.levels.WARN) end
      --     end, 2000)
      --   end,
      -- })

      local monorepo = require("lsp.monorepo")
      monorepo.setup_lsp_with_monorepo()

      local function load_project_config()
        local config_files = { ".nvim.lua", ".nvimrc.lua", ".nvim/init.lua" }
        for _, config_file in ipairs(config_files) do
          local path = vim.fn.getcwd() .. "/" .. config_file
          if vim.fn.filereadable(path) == 1 then
            local lsp_load_project_config_ok, err = pcall(dofile, path)
            if lsp_load_project_config_ok then
              return
            else
              vim.notify("Error loading " .. config_file .. ": " .. err, vim.log.levels.ERROR)
            end
            break
          end
        end
      end

      vim.api.nvim_create_autocmd("DirChanged", {
        callback = load_project_config,
      })
      load_project_config()
    end,
  },
}
