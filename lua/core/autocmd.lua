vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.lua",
    command = "lua vim.lsp.buf.format()",
})