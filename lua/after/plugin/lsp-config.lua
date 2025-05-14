config = function()
    require("mason").setup()
    require("mason-lspconfig").setup({
        ensure_installed = { 
            "lua_ls",
            "ts_ls",
            "pyright",
            "omnisharp"
        }
    })
    -- 
    local capabilities = require("cmp_nvim_lsp").default_capabilities(
    local lspconfig = require("lspconfig")
    lspconfig.lua_ls.setup({
        capabilities = capabilities
    })
    lspconfig.ts_ls.setup({
        capabilities = capabilities
    })

    vim.keymap.set('n', 'K', vim.lsp.buf.hover, {})
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {})
end