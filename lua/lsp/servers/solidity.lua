local shared = require("lsp.shared")

local M = {}

function M.setup()
  local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
  if not lspconfig_ok then
    vim.notify("lspconfig not found", vim.log.levels.ERROR)
    return
  end

  local capabilities = shared.get_capabilities()

  -- Setup solidity_ls (Solidity Language Server)
  lspconfig.solidity_ls.setup({
    capabilities = capabilities,
    on_attach = function(client, bufnr)
      -- Setup LSP keymaps
      shared.setup_keymaps()

      -- Enable formatting if supported
      if client.supports_method("textDocument/formatting") then
        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer = bufnr,
          callback = function()
            if vim.b.lsp_format_on_save ~= false then
              vim.lsp.buf.format({
                bufnr = bufnr,
                filter = function(c)
                  return c.name == "solidity_ls"
                end,
              })
            end
          end,
        })
      end

      vim.notify(
        string.format("Solidity LSP attached to buffer %d", bufnr),
        vim.log.levels.INFO
      )
    end,

    -- Solidity-specific settings
    settings = {
      solidity = {
        -- Compiler settings
        compileUsingRemoteVersion = "latest", -- or specific version like "v0.8.19+commit.7dd6d404"
        compileUsingLocalVersion = "", -- Path to local solc binary

        -- Formatter settings
        formatter = "forge",

        -- Linting settings
        enabledAsYouTypeCompilationErrorCheck = true,
        validationDelay = 1500,

        -- Package manager settings
        packageDefaultDependenciesContractsDirectory = "contracts",
        packageDefaultDependenciesDirectory = "lib",

        -- Mocha settings for testing
        mocha = {
          enabled = false,
          optionsPath = "./test/.mocharc.json"
        },

        -- Hardhat/Foundry support
        defaultCompiler = "remote", -- "remote", "localFile", "localNodeModule"

        -- Analysis settings
        analysisLevel = "full", -- "full", "basic", "none"

        -- IntelliSense settings
        enableIncrementalCompilation = true,
      }
    },

    -- File patterns for Solidity files
    filetypes = { "solidity" },

    -- Root directory detection
    root_dir = lspconfig.util.root_pattern(
      "hardhat.config.js",
      "hardhat.config.ts",
      "foundry.toml",
      "truffle-config.js",
      "truffle.js",
      "remappings.txt",
      ".git"
    ),

    -- Single file support
    single_file_support = true,

    -- Additional initialization options
    init_options = {
      -- Enable/disable certain features
      enableTelemetry = false,
    },
  })

  -- Setup additional Solidity-related autocmds and configurations
  M.setup_solidity_autocmds()

  vim.notify("Solidity LSP configured", vim.log.levels.INFO)
end

function M.setup_solidity_autocmds()
  local augroup = vim.api.nvim_create_augroup("SolidityLSP", { clear = true })

  -- Set specific options for Solidity files
  vim.api.nvim_create_autocmd("FileType", {
    group = augroup,
    pattern = "solidity",
    callback = function()
      -- Set indentation for Solidity files
      vim.opt_local.tabstop = 4
      vim.opt_local.shiftwidth = 4
      vim.opt_local.expandtab = true

      -- Set comment string for Solidity
      vim.opt_local.commentstring = "// %s"

      -- Enable spell check in comments
      vim.opt_local.spell = false

      -- Set fold method
      vim.opt_local.foldmethod = "syntax"

      vim.notify("Solidity file settings applied", vim.log.levels.DEBUG)
    end,
  })

  -- Auto-detect Solidity files that might not have .sol extension
  vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
    group = augroup,
    pattern = {"*.sol"},
    callback = function()
      vim.bo.filetype = "solidity"
    end,
  })
end

-- Helper function to check if solidity_ls is available
function M.check_solidity_ls()
  local handle = io.popen("solidity-language-server --version 2>/dev/null")
  if handle then
    local result = handle:read("*a")
    handle:close()
    if result and result ~= "" then
      vim.notify("solidity-language-server found: " .. result:gsub("\n", ""), vim.log.levels.INFO)
      return true
    end
  end

  vim.notify(
    "solidity-language-server not found. Install it via Mason or npm: npm install -g @nomicfoundation/solidity-language-server",
    vim.log.levels.WARN
  )
  return false
end

-- Setup function to be called from your main LSP configuration
function M.mason_setup()
  local mason_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
  if not mason_ok then
    vim.notify("mason-lspconfig not found", vim.log.levels.ERROR)
    return
  end

  -- Ensure solidity language server is installed via Mason
  -- Note: Mason package name is different from lspconfig name
  mason_lspconfig.setup({
    ensure_installed = { "solidity" }, -- Mason package name is "solidity", not "solidity_ls"
    automatic_installation = true,
  })
end

return M
