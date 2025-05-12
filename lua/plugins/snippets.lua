-- ============================================================================
-- LuaSnip Configuration — plugins/snippets.lua
-- ============================================================================
-- Snippet engine for Neovim with support for VSCode-style snippets
-- ============================================================================

local luasnip = pcall(require, "luasnip")
local luasnipcode = pcall(require, "luasnip.loaders.from_vscode")

luasnipcode.lazy_load() -- Load from friendly-snippets

luasnip.config.set_config({
  history = true,
  updateevents = "TextChanged,TextChangedI",
  enable_autosnippets = true,
})
