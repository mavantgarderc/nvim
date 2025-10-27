return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local fn = vim.fn
      local g = vim.g

      require("luasnip.loaders.from_vscode").lazy_load()
      luasnip.filetype_extend("javascript", { "javascriptreact" })
      luasnip.filetype_extend("typescript", { "typescriptreact" })

      if g.have_nerd_font == nil then
        g.have_nerd_font = fn.has("nvim-0.7") == 1
      end

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
        ---@diagnostic disable-next-line: different-requires
        mapping = require("core.keymaps.cmp").get_mappings(),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer", keyword_length = 3 },
        }),
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = function(entry, vim_item)
            local kind_icons = {
              Text = "󰉿 ",
              Method = "󰆧 ",
              Function = "󰡱 ",
              Constructor = " ",
              Field = "󰜢 ",
              Variable = "󰀫",
              Class = "󰠱 ",
              Interface = " ",
              Module = " ",
              Property = "󰜢 ",
              Unit = "󰑭 ",
              Value = "󱜪 ",
              Enum = " ",
              Keyword = "󰌋 ",
              Snippet = " ",
              Color = "󰏘 ",
              File = "󰈙 ",
              Reference = "󰈇 ",
              Folder = "󰉋 ",
              EnumMember = " ",
              Constant = "󰏿 ",
              Struct = "󰙅 ",
              Event = " ",
              Operator = "󰆕 ",
              TypeParameter = "",
            }

            if not g.have_nerd_font then
              for k, _ in pairs(kind_icons) do
                kind_icons[k] = ""
              end
            end

            vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind] or "", vim_item.kind)

            local source_names = {
              nvim_lsp = "[LSP]",
              luasnip = "[Snp]",
              buffer = "[Buf]",
              path = "[Pth]",
              nvim_lua = "[Lua]",
              cmdline = "[CMD]",
            }
            vim_item.menu = source_names[entry.source.name] or string.format("[%s]", entry.source.name)

            local label = vim_item.abbr
            local truncated_label = fn.strcharpart(label, 0, 40)
            if truncated_label ~= label then
              vim_item.abbr = truncated_label .. "..."
            end

            return vim_item
          end,
        },
        experimental = {
          ghost_text = true,
        },
      })
    end,
  },
}
