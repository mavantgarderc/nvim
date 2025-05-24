-- local lsp = require("lsp-zero")
-- 
-- -- Reserve a space in the gutter
-- vim.opt.signcolumn = 'yes'
-- 
-- -- Add cmp_nvim_lsp capabilities settings to lspconfig
-- -- This should be executed before you configure any language server
-- local lspconfig_defaults = require('lspconfig').util.default_config
-- lspconfig_defaults.capabilities = vim.tbl_deep_extend(
--     'force',
--     lspconfig_defaults.capabilities,
--     require('cmp_nvim_lsp').default_capabilities()
-- )
-- 
-- -- This is where you enable features that only work
-- -- if there is a language server active in the file
-- vim.api.nvim_create_autocmd('LspAttach', {
--     desc = 'LSP actions',
--     callback = function(event)
--         local opts = {buffer = event.buf}
-- 
--         vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
--         vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
--         vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
--         vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
--         vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
--         vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
--         vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
--         vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
--         vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
--         vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
--     end,
-- })
-- 
-- -- These are just examples. Replace them with the language
-- -- servers you have installed in your system
-- require('mason').setup({})
-- require('mason-lspconfig').setup({
--     -- Replace the language servers listed here
--     -- with the ones you want to install
--     ensure_installed = {'lua_ls', 'ts_ls', 'pyright', 'omnisharp'},
--     handlers = {
--         function(server_name)
--             require('lspconfig')[server_name].setup({})
--         end,
--     },
-- })
-- require('lspconfig').lua_ls.setup({})
-- require('lspconfig').ts_ls.setup({})
-- require('lspconfig').pyright.setup({})
-- require('lspconfig').omnisharp.setup({})
-- 
-- require('luasnip.loaders.from_vscode').lazy_load()
-- 
-- vim.opt.signcolumn = 'yes'
-- 
-- -- Add cmp_nvim_lsp capabilities settings to lspconfig
-- -- This should be executed before you configure any language server
-- local lspconfig_defaults = require('lspconfig').util.default_config
-- lspconfig_defaults.capabilities = vim.tbl_deep_extend(
--     'force',
--     lspconfig_defaults.capabilities,
--     require('cmp_nvim_lsp').default_capabilities()
-- )
-- 
-- local cmp = require('cmp')
-- -- completion settings
-- cmp.setup({
--     sources = {
--         {name = 'nvim_lsp'},
--         {name = 'luasnip'},
--         {name = "pyright"},
--         {name = "omnisharp"},
--     },
--     snippet = {
--         expand = function(args)
--             -- You need Neovim v0.10 to use vim.snippet
--             vim.snippet.expand(args.body)
--         end,
--     },
--     -- completion menu borders
--     window = {
--         completion = cmp.config.window.bordered(),
--         documentation = cmp.config.window.bordered(),
--     },
--     cmp.setup({
--         mapping = cmp.mapping.preset.insert({
--             ["<C-y>"] = cmp.mapping.confirm({select=true}),
--             ["<C-p>"] = cmp.mapping.scroll_docs(-4),
--             ["<C-n>"] = cmp.mapping.scroll_docs(4),
--             -- Jump to the next snippet placeholder
--             ['<C-f>'] = cmp.mapping(function(fallback)
--                 local luasnip = require('luasnip')
--                 if luasnip.locally_jumpable(1) then
--                     luasnip.jump(1)
--                 else
--                     fallback()
--                 end
--             end, {'i', 's'}),
--             -- Jump to the previous snippet placeholder
--             ['<C-b>'] = cmp.mapping(function(fallback)
--                 local luasnip = require('luasnip')
--                 if luasnip.locally_jumpable(-1) then
--                     luasnip.jump(-1)
--                 else
--                     fallback()
--                 end
--             end, {'i', 's'}),
--         }),
--     })
-- })
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
-- =======================================================

-- lua/after/plugins/lsp.lua

-- Reserve a space in the gutter
vim.opt.signcolumn = 'yes'

-- Enhance LSP capabilities
local lspconfig_defaults = require('lspconfig').util.default_config
lspconfig_defaults.capabilities = vim.tbl_deep_extend(
    'force',
    lspconfig_defaults.capabilities,
    require('cmp_nvim_lsp').default_capabilities()
)

-- Keymaps when LSP attaches
vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP actions',
    callback = function(event)
        local opts = { buffer = event.buf }
        local map = vim.keymap.set
        -- definition in the same buffer
        map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
        -- go to definition in the same buffer
        -- jump to the typ eof the word under cursor
        map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
        map('n', 'grd', require("telescope.builtin").lsp_definitions, opts)
        -- go to declaration
        map('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
        -- go to declaration
        map('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
        map('n', 'gri', require("telescope.builtin").lsp_implementations, opts)
        -- <?> jump to definition
        map('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
        -- list of references in the current buffer
        map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
        -- map('n', 'grr', require("telescope.builtin").lsp_reference, opts)
        -- done la-copy-pasta <?>
        map('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
        -- rename all in the current buffer
        map('n', 'grn', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
        -- code action
        map({ 'n', 'x' }, 'gra', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
        -- <?> done la-copy-pasta
        map({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
        -- fuzzy find all the symbols in nyour current doc
        map('n', 'gO', require("telescope.builtin").lsp_document_symbols, opts)
    end,
})

-- diagnostics config
vim.diagnostic.config {
    severity_sort = true,
    float = { border = 'rounded', source = 'if_many' },
    underline = { severity = vim.diagnostic.severity.ERROR },
    signs = vim.g.have_nerd_font and {
        text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
        },
    } or {},
    virtual_text = {
        source = 'if_many',
        spacing = 2,
        format = function(diagnostic)
            local diagnostic_message = {
                [vim.diagnostic.severity.ERROR] = diagnostic.message,
                [vim.diagnostic.severity.WARN] = diagnostic.message,
                [vim.diagnostic.severity.INFO] = diagnostic.message,
                [vim.diagnostic.severity.HINT] = diagnostic.message,
            }
            return diagnostic_message[diagnostic.severity]
        end,
    },
}

-- Mason & LSP configuration
require('mason').setup()
require('mason-lspconfig').setup({
    ensure_installed = {'lua_ls', 'ts_ls', 'pyright', 'omnisharp'},
    automatic_installation = true,
    handlers = {
        function(server_name)
            require('lspconfig')[server_name].setup({})
        end,
    },
})

-- Snippets
require('luasnip.loaders.from_vscode').lazy_load()

-- nvim-cmp setup
local cmp = require('cmp')
cmp.setup({
    sources = {
        {name = 'nvim_lsp'},
        {name = 'luasnip'},
        {name = 'pyright'},
        {name = 'omnisharp'},
    },
    snippet = {
        expand = function(args)
            vim.snippet.expand(args.body)
        end,
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ["<C-y>"] = cmp.mapping.confirm({select=true}),
        ["<C-p>"] = cmp.mapping.scroll_docs(-4),
        ["<C-n>"] = cmp.mapping.scroll_docs(4),
        ['<C-f>'] = cmp.mapping(function(fallback)
            local luasnip = require('luasnip')
            if luasnip.locally_jumpable(1) then
                luasnip.jump(1)
            else
                fallback()
            end
        end, {'i', 's'}),
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
