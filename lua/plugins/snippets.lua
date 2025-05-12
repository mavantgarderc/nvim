-- ============================================================================
-- LuaSnip Configuration — plugins/snippets.lua
-- ============================================================================
-- Snippet engine for Neovim with support for VSCode-style snippets
-- ============================================================================

local luasnip = require("luasnip")

require("luasnip.loaders.from_vscode").lazy_load() -- Load from friendly-snippets

luasnip.config.set_config({
  history = true,
  updateevents = "TextChanged,TextChangedI",
  enable_autosnippets = true,
})
