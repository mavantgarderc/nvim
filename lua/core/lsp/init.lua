-- ============================================================================
-- LSP Setup Entrypoint — core/lsp/init.lua
-- ============================================================================
-- Initializes LSP servers configured via mason-lspconfig and lspconfig
-- ============================================================================

require("mason")

local handlers = require("core.lsp.handlers")
local lspconfig = require("lspconfig")

-- List your LSP servers
local servers = {
  "ts_ls", "pyright", "lua_ls",
  "bashls", "html", "cssls",
  "omnisharp",
  "clangd", "jsonls", "taplo", "yamlls",
}

-- Explicit LSP setup loop
for _, server in ipairs(servers) do
  local opts = {
    on_attach = handlers.on_attach,
    capabilities = handlers.capabilities,
  }

  if server == "lua_ls" then
    opts.settings = {
      Lua = {
        diagnostics = { globals = { "vim" } },
        workspace = {
          library = vim.api.nvim_get_runtime_file("", true),
          checkThirdParty = false,
        },
        telemetry = { enable = false },
      }
    }
  end

  lspconfig[server].setup(opts)
end
