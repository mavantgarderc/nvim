return {
    {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v3.x",
        dependencies = {
            "neovim/nvim-lspconfig",
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/nvim-cmp",
            "hrsh7th/cmp-nvim-lsp",
            "L3MON4D3/LuaSnip",
            "nvimtools/none-ls.nvim",
        },

        config = function()
            local lsp = require("lsp-zero").preset({})
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            local diagnostic = vim.diagnostic
            local g = vim.g
            local map = vim.keymap.set
            local api = vim.api
            local fn = vim.fn
            local buf = vim.lsp.buf
            vim.opt.signcolumn = "yes"

            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "ts_ls",
                    "pyright",
                    "omnisharp",
                },
                automatic_installation = true,
                handlers = {
                    lsp.default_setup,
                },
            })

            lsp.on_attach(function(_, bufnr) lsp.default_keymaps({ buffer = bufnr }) end)

            api.nvim_create_autocmd("LspAttach", {
                desc = "LSP actions",
                callback = function(event)
                    local opts = { buffer = event.buf }
                    map("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
                    map("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
                    map("n", "grd", require("telescope.builtin").lsp_definitions, opts)
                    -- map('n', 'grd', require("telescope.builtin").definitions, opts)
                    map("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
                    map("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
                    map("n", "gri", require("telescope.builtin").lsp_implementations, opts)
                    map("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
                    -- map('n', 'grr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
                    -- map('n', 'grr', require("telescope.builtin").lsp_reference, opts)
                    -- done la-copy-pasta <?>
                    map("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
                    map("n", "grn", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
                    map({ "n", "x" }, "gra", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
                    -- <?> done la-copy-pasta
                    -- map({ "n", "x" }, "<F3>", function()
                    --     -- 1. vim.lsp.buf.format({ async = true })
                    --     vim.lsp.buf.format({
                    --         async = true,
                    --         filter = function(client)
                    --             return client.name ~= "ts_ls"
                    --         end,
                    --     })
                    -- end)
                    map("n", "gO", require("telescope.builtin").lsp_document_symbols, opts)
                end,
            })

            diagnostic.config({
                severity_sort = true,
                float = { border = "rounded", source = "if_many" },
                underline = { severity = diagnostic.severity.ERROR },
                signs = g.have_nerd_font and {
                    text = {
                        [vim.diagnostic.severity.ERROR] = "󰅚 ",
                        [vim.diagnostic.severity.WARN] = "󰀪 ",
                        [vim.diagnostic.severity.INFO] = "󰋽 ",
                        [vim.diagnostic.severity.HINT] = "󰌶 ",
                    },
                } or {},
                virtual_text = {
                    source = "if_many",
                    spacing = 2,
                    format = function(diagnostic) return diagnostic.message end,
                },
            })

            require("luasnip.loaders.from_vscode").lazy_load()

            cmp.setup({
                sources = {
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "omnisharp" },
                },
                snippet = {
                    expand = function(args) luasnip.lsp_expand(args.body) end,
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-y>"] = cmp.mapping.confirm({ select = true }),
                    ["<C-p>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-n>"] = cmp.mapping.scroll_docs(4),
                    ["<C-f>"] = cmp.mapping(function(fallback)
                        if luasnip.locally_jumpable(1) then
                            luasnip.jump(1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<C-b>"] = cmp.mapping(function(fallback)
                        if luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
            })

            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            local lspconfig = require("lspconfig")

            lspconfig.lua_ls.setup({ capabilities = capabilities })
            lspconfig.ts_ls.setup({ capabilities = capabilities })
            lspconfig.pyright.setup({ capabilities = capabilities })
            lspconfig.omnisharp.setup({
                cmd = {
                    "omnisharp",
                    "--languageserver",
                    "--hostPID",
                    tostring(fn.getpid()),
                },
                capabilities = capabilities,
            })

            local null_ls = require("null-ls")
            null_ls.setup({
                sources = {
                    null_ls.builtins.formatting.stylua,
                    null_ls.builtins.formatting.csharpier,
                },
            })

            map("n", "<leader>gf", function()
                buf.format({
                    async = true,
                    filter = function(client) return client.name ~= "ts_ls" end,
                })
            end, { desc = "Format with LSP/none-ls" })

            lsp.setup()
        end,
    },
}
