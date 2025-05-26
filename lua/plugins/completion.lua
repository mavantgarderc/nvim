return {
    {
        -- Main completion engine
        "hrsh7th/nvim-cmp",
        dependencies = {
            -- LSP completion source
            "hrsh7th/cmp-nvim-lsp",
            -- Snippet engine
            "L3MON4D3/LuaSnip",
            -- Completion source for snippets
            "saadparwaiz1/cmp_luasnip",
            -- Predefined snippets
            "rafamadriz/friendly-snippets",
        },

        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")
            require("luasnip.loaders.from_vscode").lazy_load()

            local cmp_mappings = require("after.plugin.completion")

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                mapping = cmp_mappings, require("after.plugin.completion"),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "buffer" },
                }),
            })
        end

    },
}
