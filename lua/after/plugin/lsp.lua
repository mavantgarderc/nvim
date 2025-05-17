local lsp = require("lsp-zero")

-- Reserve a space in the gutter
vim.opt.signcolumn = 'yes'

-- Add cmp_nvim_lsp capabilities settings to lspconfig
-- This should be executed before you configure any language server
local lspconfig_defaults = require('lspconfig').util.default_config
lspconfig_defaults.capabilities = vim.tbl_deep_extend(
    'force',
    lspconfig_defaults.capabilities,
    require('cmp_nvim_lsp').default_capabilities()
)

-- This is where you enable features that only work
-- if there is a language server active in the file
vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP actions',
    callback = function(event)
        local opts = {buffer = event.buf}

        vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
        vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
        vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
        vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
        vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
        vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
        vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
        vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
        vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
        vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
    end,
})

-- These are just examples. Replace them with the language
-- servers you have installed in your system
require('mason').setup({})
require('mason-lspconfig').setup({
    -- Replace the language servers listed here
    -- with the ones you want to install
    ensure_installed = {'lua_ls', 'ts_ls', 'pyright', 'omnisharp'},
    handlers = {
        function(server_name)
            require('lspconfig')[server_name].setup({})
        end,
    },
})
require('lspconfig').lua_ls.setup({})
require('lspconfig').ts_ls.setup({})
require('lspconfig').pyright.setup({})
require('lspconfig').omnisharp.setup({})

require('luasnip.loaders.from_vscode').lazy_load()

vim.opt.signcolumn = 'yes'

-- Add cmp_nvim_lsp capabilities settings to lspconfig
-- This should be executed before you configure any language server
local lspconfig_defaults = require('lspconfig').util.default_config
lspconfig_defaults.capabilities = vim.tbl_deep_extend(
    'force',
    lspconfig_defaults.capabilities,
    require('cmp_nvim_lsp').default_capabilities()
)

local cmp = require('cmp')
-- completion settings
cmp.setup({
    sources = {
        {name = 'nvim_lsp'},
        {name = 'luasnip'},
        {name = "pyright"},
        {name = "omnisharp"},
    },
    snippet = {
        expand = function(args)
            -- You need Neovim v0.10 to use vim.snippet
            vim.snippet.expand(args.body)
        end,
    },
    -- completion menu borders
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    cmp.setup({
        mapping = cmp.mapping.preset.insert({
            ["<C-y>"] = cmp.mapping.confirm({select=true}),
            ["<C-p>"] = cmp.mapping.scroll_docs(-4),
            ["<C-n>"] = cmp.mapping.scroll_docs(4),
            -- Jump to the next snippet placeholder
            ['<C-f>'] = cmp.mapping(function(fallback)
                local luasnip = require('luasnip')
                if luasnip.locally_jumpable(1) then
                    luasnip.jump(1)
                else
                    fallback()
                end
            end, {'i', 's'}),
            -- Jump to the previous snippet placeholder
            ['<C-b>'] = cmp.mapping(function(fallback)
                local luasnip = require('luasnip')
                if luasnip.locally_jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end, {'i', 's'}),
        }),
    })
})
-- ===========================================================================================
-- -- primagen suggested (outdated)
-- lsp.ensure_install({
--     "tsserver",
--     "eslint",
--     "sumneko_lua",
--     "pyright",
--     "omnisharp",
-- })
-- -- completion settings
-- local cmp = require("cmp")
-- local cmp_select = { behavior = cmp.SelectBehavior.Select }
-- local cmp_mappings = lsp.defaults.cmp_mappings({
--     ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
--     ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
--     ["<C-y>"] = cmp.mapping.confirm({ select = true })
-- })
-- lsp.set_preferences ({ sign_icons = { } })
-- lsp.on_attach(function(client, bufnr)
    --         print("help")
    --     local opts = { buffer = bufnr, remap = false }
    --     local cks = vim.keymap.set
    --     cks("n", "gd", function() vim.lsp.buf.definition() end, opts)
    --     cks("n", "K", function() vim.lsp.buf.hover() end, opts)
    --     cks("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
    --     cks("n", "<leader>vd", function() vim.diagnostics.open_float() end, opts)
    --     cks("n", "[d", function() vim.diagnostics.goto_next() end, opts)
    --     cks("n", "]d", function() vim.diagnostics.goto_prev() end, opts)
    --     cks("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
    --     cks("n", "<leawder>vrr", function() vim.lsp.buf.references() end, opts)
    --     cks("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
    --     cks("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
    -- end)
