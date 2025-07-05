return {
    "L3MON4D3/LuaSnip",
    version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
    dependencies = {
        "rafamadriz/friendly-snippets",
        "saadparwaiz1/cmp_luasnip",
    },
    build = "make install_jsregexp", -- install jsregexp (optional)
    config = function()
        local ls = require("luasnip")
        local types = require("luasnip.util.types")

        ls.config.set_config({
            -- This tells LuaSnip to remember to keep around the last snippet.
            -- You can jump back into it even if you move outside of the selection
            history = true,

            -- This one is cool cause if you have dynamic snippets, it updates as you type!
            updateevents = "TextChanged,TextChangedI",

            -- Autosnippets:
            enable_autosnippets = true,

            -- Crazy highlights!!
            ext_opts = {
                [types.choiceNode] = {
                    active = {
                        virt_text = { { " « ", "NonTest" } },
                    },
                },
            },
        })

        -- Load friendly-snippets
        require("luasnip.loaders.from_vscode").lazy_load()

        -- Load custom snippets (if you have any)
        -- require("luasnip.loaders.from_vscode").lazy_load({ paths = { "./my-snippets" } })
    end,
}
