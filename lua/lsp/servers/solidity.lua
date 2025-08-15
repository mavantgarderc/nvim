local shared = require("lsp.shared")

local M = {}

local notify = vim.notify
local b = vim.b
local bo = vim.bo
local lsp = vim.lsp
local log = vim.log
local api = vim.api
local notify = vim.notify
local opt_local = vim.opt_local

function M.setup()
  local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
  if not lspconfig_ok then
    notify("lspconfig not found", log.levels.ERROR)
    return
  end

  local capabilities = shared.get_capabilities()

  lspconfig.solidity_ls.setup({
    capabilities = capabilities,
    on_attach = function(client, bufnr)
      shared.setup_keymaps()

      if client.supports_method("textDocument/formatting") then
        api.nvim_create_autocmd("BufWritePre", {
          buffer = bufnr,
          callback = function()
            if b.lsp_format_on_save ~= false then
              lsp.buf.format({
                bufnr = bufnr,
                filter = function(c)
                  return c.name == "solidity_ls"
                end,
              })
            end
          end,
        })
      end

      -- notify(
      --   string.format("Solidity LSP attached to buffer %d", bufnr),
      --   log.levels.INFO
      -- )
    end,

    settings = {
      solidity = {
        compileUsingRemoteVersion = "latest",
        compileUsingLocalVersion = "",

        formatter = "forge",

        enabledAsYouTypeCompilationErrorCheck = true,
        validationDelay = 1500,

        packageDefaultDependenciesContractsDirectory = "contracts",
        packageDefaultDependenciesDirectory = "lib",

        mocha = {
          enabled = false,
          optionsPath = "./test/.mocharc.json"
        },

        defaultCompiler = "remote", -- "remote", "localFile", "localNodeModule"

        analysisLevel = "full", -- "full", "basic", "none"

        enableIncrementalCompilation = true,
      }
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

    init_options = {
      enableTelemetry = false,
    },
  })

  M.setup_solidity_autocmds()

  -- notify("Solidity LSP configured", log.levels.INFO)
end

function M.setup_solidity_autocmds()
  local augroup = api.nvim_create_augroup("SolidityLSP", { clear = true })

  api.nvim_create_autocmd("FileType", {
    group = augroup,
    pattern = "solidity",
    callback = function()
      opt_local.tabstop = 4
      opt_local.shiftwidth = 4
      opt_local.expandtab = true

      opt_local.commentstring = "// %s"

      opt_local.spell = false

      opt_local.foldmethod = "syntax"

      -- notify("Solidity file settings applied", log.levels.DEBUG)
    end,
  })

  api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
    group = augroup,
    pattern = {"*.sol"},
    callback = function()
      bo.filetype = "solidity"
    end,
  })
end

function M.check_solidity_ls()
  local handle = io.popen("solidity-language-server --version 2>/dev/null")
  if handle then
    local result = handle:read("*a")
    handle:close()
    if result and result ~= "" then
      -- notify("solidity-language-server found: " .. result:gsub("\n", ""), log.levels.INFO)
      return true
    end
  end

  -- notify(
  --   "solidity-language-server not found. Install it via Mason or npm: npm install -g @nomicfoundation/solidity-language-server",
  --   log.levels.WARN
  -- )
  return false
end

function M.mason_setup()
  local mason_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
  if not mason_ok then
    notify("mason-lspconfig not found", log.levels.ERROR)
    return
  end

  mason_lspconfig.setup({
    ensure_installed = { "solidity" },
    automatic_installation = true,
  })
end

return M
