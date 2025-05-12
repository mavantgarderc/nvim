-- ============================================================================
-- nvim-cmp Configuration — plugins/cmp.lua
-- ============================================================================
-- Autocompletion setup for Neovim with nvim-cmp, luasnip, treesitter, and signature help
-- ============================================================================

local cmp = require("cmp")
local luasnip = require("luasnip")
local lspcmp = require("cmp_nvim_lsp")
local lspkind = require("lspkind")

-- Setup nvim-cmp
cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = {
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  },
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "nvim_lsp_signature_help" },
    { name = "treesitter" },
    { name = "path" },
    { name = "buffer" },
  }),
  formatting = {
    format = lspkind.cmp_format({
      mode = "symbol_text",
      maxwidth = 50,
      ellipsis_char = "…",
    }),
  },
})

-- Setup LSP capabilities globally (optional; useful for LSP config files)
vim.g.cmp_capabilities = lspcmp.default_capabilities(
  vim.lsp.protocol.make_client_capabilities()
)

-- ============================================================================
-- ✅ nvim-cmp configured with luasnip, lspkind, signature help, treesitter
-- ============================================================================
