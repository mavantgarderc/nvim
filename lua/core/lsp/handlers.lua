-- ============================================================================
-- LSP Handlers & Capabilities — core/lsp/handlers.lua
-- ============================================================================
-- This file contains LSP handler functions, including the global `on_attach`
-- function and capabilities configuration for nvim-cmp integration.
-- ============================================================================

local M = {}

-- ============================================================================
-- Enhanced LSP Capabilities for nvim-cmp Integration
-- ============================================================================
-- This adds enhanced LSP client capabilities, including nvim-cmp integration.
local cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
M.capabilities = cmp_nvim_lsp.default_capabilities()

-- ============================================================================
-- Global `on_attach` Function for All LSP Clients
-- ============================================================================
-- This function is called when an LSP client attaches to a buffer. It sets up
-- key mappings for common LSP functions and configures auto-formatting for
-- clients that support it.
M.on_attach = function(client, bufnr)
  -- Helper function for mapping keys
  local map = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, {
      noremap = true,
      silent = true,
      buffer = bufnr,
      desc = desc
    })
  end

  -- ============================================================================
  -- Core LSP Key Mappings
  -- ============================================================================
  map("n", "gd", vim.lsp.buf.definition,        "LSP: Go to Definition")
  map("n", "gr", vim.lsp.buf.references,        "LSP: Find References")
  map("n", "K",  vim.lsp.buf.hover,             "LSP: Hover Documentation")
  map("n", "<leader>rn", vim.lsp.buf.rename,    "LSP: Rename Symbol")
  map("n", "<leader>ca", vim.lsp.buf.code_action, "LSP: Code Actions")

  -- ============================================================================
  -- Diagnostics Navigation Key Mappings (Optional)
  -- ============================================================================
  map("n", "[d", vim.diagnostic.goto_prev, "LSP: Previous Diagnostic")
  map("n", "]d", vim.diagnostic.goto_next, "LSP: Next Diagnostic")
  map("n", "<leader>e", vim.diagnostic.open_float, "LSP: Show Diagnostic")
  map("n", "<leader>q", vim.diagnostic.setloclist, "LSP: Quickfix Diagnostics")

  -- ============================================================================
  -- Auto-Format on Save (Optional, for clients that support it)
  -- ============================================================================
  if client.server_capabilities.documentFormattingProvider then
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format({ bufnr = bufnr })
      end,
      desc = "LSP: Auto-format on save",
    })
  end
end

-- ============================================================================
-- Return the module
-- ============================================================================
return M
