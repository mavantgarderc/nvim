local M = {}

function M.setup(bufnr)
  local map = function(mode, lhs, rhs, desc)
    local opts = { noremap = true, silent = true, buffer = bufnr, desc = desc }
    vim.keymap.set(mode, lhs, rhs, opts)
  end

  map("n", "gd", vim.lsp.buf.definition, "Go to Definition")
  map("n", "K", vim.lsp.buf.hover, "Hover Documentation")
  map("n", "gi", vim.lsp.buf.implementation, "Go to Implementation")
  map("n", "<leader>rn", vim.lsp.buf.rename, "Rename Symbol")
  map("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
  map("n", "gr", vim.lsp.buf.references, "References")
  map("n", "<leader>f", function()
    vim.lsp.buf.format({ async = true })
  end, "Format Buffer")
end

return M