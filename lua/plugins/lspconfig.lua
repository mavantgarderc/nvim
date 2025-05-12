-- ============================================================================
-- LSP Configuration — plugins/lspconfig.lua
-- ============================================================================
-- Language Server Protocol setup for multiple languages
-- ============================================================================

local lspconfig = require("lspconfig")

-- Setup for C#
lspconfig.omnisharp.setup({
  cmd = { "omnisharp" },
  root_dir = lspconfig.util.root_pattern("*.sln", "*.csproj"),
  init_options = {
    FormattingOptions = {
      EnableEditorConfigSupport = true,
      EnableRangeFormatting = true,
      TabSize = 4,
      InsertSpaces = true,
    },
  },

  -- Enable OmniSharp LSP features
  on_attach = function(client, bufnr)
    -- Keymaps for C# LSP features
    vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { desc = "Go to definition" })
    vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, { desc = "Find references" })
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions" })
    vim.keymap.set("n", "<leader>f", vim.lsp.buf.formatting, { desc = "Format code" })
    vim.keymap.set("n", "<leader>e", vim.lsp.diagnostic.show_line_diagnostics, { desc = "Show diagnostics" })
  end,

  -- Diagnostics settings
  handlers = {
    ["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
      virtual_text = { prefix = "●", spacing = 0 },
      signs = true,
      update_in_insert = true,
    }),
  },
})

-- Setup for Python
lspconfig.pyright.setup({
  on_attach = function(client, bufnr)
    -- Keymaps for Python LSP features
    vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { desc = "Go to definition" })
    vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, { desc = "Find references" })
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions" })
    vim.keymap.set("n", "<leader>f", vim.lsp.buf.formatting, { desc = "Format code" })
    vim.keymap.set("n", "<leader>e", vim.lsp.diagnostic.show_line_diagnostics, { desc = "Show diagnostics" })
  end,
})

-- Setup for TypeScript
lspconfig.ts_ls.setup({
  on_attach = function(client, bufnr)
    -- Keymaps for TypeScript LSP features
    vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, { desc = "Go to definition" })
    vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, { desc = "Find references" })
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions" })
    vim.keymap.set("n", "<leader>f", vim.lsp.buf.formatting, { desc = "Format code" })
    vim.keymap.set("n", "<leader>e", vim.lsp.diagnostic.show_line_diagnostics, { desc = "Show diagnostics" })
  end,
})

-- Setup for other LSPs can be added below

-- ============================================================================
-- LSP Initialized
-- ============================================================================