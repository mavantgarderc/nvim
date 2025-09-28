local shared = require("lsp.shared")

local M = {}

function M.setup()
  local capabilities = shared.get_capabilities()

  require('lspconfig').solidity_ls.setup({
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
              filter = function(c) return c.name == "solidity_ls" end,
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
      },
    },
    filetypes = { "solidity" },
    root_markers = {
      "hardhat.config.js",
      "hardhat.config.ts",
      "foundry.toml",
      "truffle-config.js",
      "truffle.js",
      "remappings.txt",
      ".git",
    },
    single_file_support = true,
    init_options = {
      enableTelemetry = false,
    },
  })

  M.setup_solidity_autocmds()
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
    pattern = { "*.sol" },
    callback = function(args)
      vim.bo[args.buf].filetype = "solidity"
    end,
  })
end

function M.mason_setup()
  local ok, mason_lspconfig = pcall(require, "mason-lspconfig")
  if not ok then
    vim.notify("mason-lspconfig not found", vim.log.levels.ERROR)
    return
  end

  mason_lspconfig.setup({
    ensure_installed = { "solidity_ls" },
    automatic_installation = true,
  })
end

return M
