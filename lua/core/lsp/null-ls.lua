-- ============================================================================
-- Null-ls Configuration — core/lsp/null-ls.lua
-- ============================================================================
-- This file integrates formatters, linters, and code actions as LSP sources
-- using null-ls. It provides a convenient way to configure external tools 
-- like linters and formatters for various languages and filetypes.
-- ============================================================================

local null_ls = require("null-ls")

-- ============================================================================
-- Register Null-ls Sources for Formatters, Linters, and Code Actions
-- ============================================================================

local sources = {
  -- ** Formatting Sources **
  null_ls.builtins.formatting.black.with({ extra_args = { "--fast" } }),  -- Python
  null_ls.builtins.formatting.prettier,                                   -- JS/TS/HTML/CSS/Markdown
  null_ls.builtins.formatting.stylua,                                     -- Lua
  null_ls.builtins.formatting.sqlfluff,                                   -- SQL

  -- ** Diagnostics & Linting Sources **
  null_ls.builtins.diagnostics.flake8,     -- Python
  null_ls.builtins.diagnostics.eslint,     -- JS/TS
  null_ls.builtins.diagnostics.shellcheck, -- Bash
  null_ls.builtins.diagnostics.markdownlint, -- Markdown

  -- ** Code Actions Sources **
  null_ls.builtins.code_actions.gitsigns,  -- Git hunks
}

-- ============================================================================
-- Null-ls Setup with Custom On-Attach for Formatting on Save
-- ============================================================================

null_ls.setup({
  sources = sources,

  -- Auto-formatting setup: run formatting on save if supported by the client
  on_attach = function(client, bufnr)
    -- Check if client supports formatting method
    if client.supports_method("textDocument/formatting") then
      -- Clear any existing autocommands for formatting
      vim.api.nvim_clear_autocmds({ group = "LspFormatting", buffer = bufnr })

      -- Set up BufWritePre autocommand for formatting on save
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = vim.api.nvim_create_augroup("LspFormatting", { clear = true }),
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({ bufnr = bufnr })
        end,
      })
    end
  end,
})

-- ============================================================================
-- Null-ls Integration Completed
-- ============================================================================
