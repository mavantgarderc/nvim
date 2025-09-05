local fn = vim.fn

return {
  "L3MON4D3/LuaSnip",
  version = "v2.*",
  dependencies = {
    "rafamadriz/friendly-snippets",
    "saadparwaiz1/cmp_luasnip",
  },
  build = "make install_jsregexp",
  config = function()
    local ls = require("luasnip")
    local types = require("luasnip.util.types")

    ls.config.set_config({
      history = true,

      updateevents = "TextChanged,TextChangedI",

      enable_autosnippets = true,

      ext_opts = {
        [types.choiceNode] = {
          active = {
            virt_text = { { " « ", "NonTest" } },
          },
        },
      },
    })

    require("luasnip.loaders.from_vscode").lazy_load()
    require("luasnip.loaders.from_lua").lazy_load({
      paths = fn.stdpath("config") .. "/lua/core/snippets",
    })
  end,
}
