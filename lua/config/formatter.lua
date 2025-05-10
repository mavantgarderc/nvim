local null_ls = require("null-ls")

null_ls.setup({
  sources = {
    -- Lua
    null_ls.builtins.formatting.stylua,

    -- JavaScript/TypeScript/JSON
    null_ls.builtins.formatting.prettierd,

    -- Python
    null_ls.builtins.formatting.black,
    null_ls.builtins.formatting.isort,

    -- Shell
    null_ls.builtins.formatting.shfmt,

    -- Markdown
    null_ls.builtins.formatting.markdownlint,
  },

  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({ group = "Format", buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = vim.api.nvim_create_augroup("Format", { clear = true }),
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({ bufnr = bufnr })
        end,
      })
    end
  end,
})