if #vim.api.nvim_list_uis() == 0 then
  return {
    setup = function() end,
    setup_solidity_autocmds = function() end,
    mason_setup = function() end,
  }
end

local shared = require("lsp.shared")
local M = {}

function M.setup()
  local capabilities = shared.get_capabilities()

  vim.defer_fn(function()
    local ok, lspconfig = pcall(require, "lspconfig")
    if not ok then
      vim.notify("[solidity.lua] nvim-lspconfig not found", vim.log.levels.WARN)
      return
    end

    local config_ok = pcall(require, "lspconfig.server_configurations.solidity_ls")
    if not config_ok then
      vim.notify("[solidity.lua] solidity_ls configuration not available", vim.log.levels.WARN)
      return
    end

    local setup_ok, err = pcall(function()
      lspconfig.solidity_ls.setup({
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          if shared.setup_keymaps then
            pcall(shared.setup_keymaps, bufnr)
          end

          if client.supports_method("textDocument/formatting") then
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = bufnr,
              callback = function()
                local ok, val = pcall(vim.api.nvim_buf_get_var, bufnr, "lsp_format_on_save")
                if ok and val == false then
                  return
                end
                vim.lsp.buf.format({
                  bufnr = bufnr,
                  filter = function(c)
                    return c.name == "solidity_ls"
                  end,
                })
              end,
            })
          end
        end,
        settings = {
          solidity = {
            compileUsingRemoteVersion = "latest",
            formatter = "forge",
            enabledAsYouTypeCompilationErrorCheck = true,
            validationDelay = 1500,
            packageDefaultDependenciesContractsDirectory = "contracts",
            packageDefaultDependenciesDirectory = "lib",
            defaultCompiler = "remote",
            analysisLevel = "full",
            enableIncrementalCompilation = true,
            inlayHints = {
              chainingHints = true,
              parameterHints = true,
            },
          },
        },
        filetypes = { "solidity" },
        root_dir = lspconfig.util.root_pattern(
          "hardhat.config.js",
          "hardhat.config.ts",
          "foundry.toml",
          "truffle-config.js",
          "truffle.js",
          "remappings.txt",
          ".git"
        ),
        single_file_support = true,
        init_options = { enableTelemetry = false },
      })
    end)

    if not setup_ok then
      vim.notify("[solidity.lua] Setup failed: " .. tostring(err), vim.log.levels.WARN)
    else
      M.setup_solidity_autocmds()
    end
  end, 100)
end

function M.setup_solidity_autocmds()
  local augroup = vim.api.nvim_create_augroup("SolidityLSP", { clear = true })

  vim.api.nvim_create_autocmd("FileType", {
    group = augroup,
    pattern = "solidity",
    callback = function()
      vim.opt_local.tabstop = 4
      vim.opt_local.shiftwidth = 4
      vim.opt_local.expandtab = true
      vim.opt_local.commentstring = "// %s"
      vim.opt_local.spell = false
      vim.opt_local.foldmethod = "syntax"
    end,
  })

  vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    group = augroup,
    pattern = "*.sol",
    callback = function(args)
      vim.bo[args.buf].filetype = "solidity"
    end,
  })
end

function M.mason_setup()
  local ok, mason_lspconfig = pcall(require, "mason-lspconfig")
  if not ok then
    vim.notify("[solidity.lua] mason-lspconfig not found", vim.log.levels.WARN)
    return
  end

  mason_lspconfig.setup({
    ensure_installed = { "solidity_ls" },
    automatic_installation = true,
  })
end

return M
