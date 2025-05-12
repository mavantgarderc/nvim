-- ============================================================================
-- Mason Setup — core/lsp/mason.lua
-- ============================================================================

local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")

mason.setup({
  ui = {
    border = "rounded",
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
  },
})

mason_lspconfig.setup({
  ensure_installed = {
    "ts_ls", "pyright", "lua_ls",
    "bashls", "html", "cssls",
    "gopls", "rust_analyzer", "omnisharp",
    "clangd", "jsonls", "taplo", "yamlls",
  },
  automatic_installation = true,
})
