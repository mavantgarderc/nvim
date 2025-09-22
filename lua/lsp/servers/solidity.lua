local shared = require("lsp.shared")

local M = {}

local notify = vim.notify
local b = vim.b
local bo = vim.bo
local lsp = vim.lsp
local log = vim.log
local api = vim.api
local opt_local = vim.opt_local

function M.setup()
  local capabilities = shared.get_capabilities()

  vim.lsp.config["solidity_ls"] = {
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
          optionsPath = "./test/.mocharc.json",
        },
        defaultCompiler = "remote", -- "remote", "localFile", "localNodeModule"
        analysisLevel = "full", -- "full", "basic", "none"
        enableIncrementalCompilation = true,
      },
    },

    filetypes = { "solidity" },

    root_dir = function(fname)
      return vim.fs.root(
        fname,
        { "hardhat.config.js", "hardhat.config.ts", "foundry.toml", "truffle-config.js", "truffle.js", "remappings.txt", ".git" }
      )
    end,

    single_file_support = true,

    init_options = {
      enableTelemetry = false,
    },
  }

  -- actually start the server
  vim.lsp.start(vim.lsp.config["solidity_ls"])

  M.setup_solidity_autocmds()
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
    end,
  })

  api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    group = augroup,
    pattern = { "*.sol" },
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
      return true
    end
  end
  return false
end

function M.mason_setup()
  local mason_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
  if not mason_ok then
    notify("mason-lspconfig not found", log.levels.ERROR)
    return
  end

  mason_lspconfig.setup({
    ensure_installed = { "solidity_ls" }, -- must match actual server name
    automatic_installation = true,
  })
end

return M
