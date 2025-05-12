-- ============================================================================
-- Mason Setup — core/lsp/mason.lua
-- ============================================================================

local mason = pcall(require, "mason")
local mason_lspconfig = pcall(require, "mason-lspconfig")

-- Mason UI config
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

-- mason-lspconfig setup
mason_lspconfig.setup({
  ensure_installed = {
    -- LSP server names from `nvim-lspconfig`
    "ts_ls",
    "pyright",
    "lua_ls",
    "bashls",
    "html",
    "cssls",
    "omnisharp",
    "clangd",
    "jsonls",
    "taplo",
    "yamlls",
  },
  automatic_installation = true,
})

-- mason-null-ls setup (deferred to avoid race conditions)
vim.schedule(function()
  require("mason-null-ls").setup({
    ensure_installed = { -- Formatters & Linters via null-ls
      "black",
      "prettier",
      "stylua",
      "sqlfluff",
      "flake8",
      "eslint_d",
      "shellcheck",
      "markdownlint",
    },
    automatic_installation = true,
  })
end)
