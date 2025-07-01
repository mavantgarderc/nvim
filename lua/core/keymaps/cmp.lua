local M = {}

function M.get_mappings()
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    return cmp.mapping.preset.insert({
        ["<C-Space>"] = cmp.mapping.complete(),

        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),

        ["<C-e>"] = cmp.mapping.abort(),

        ["<C-y>"] = cmp.mapping.confirm({
            select = true,
            behavior = cmp.ConfirmBehavior.Replace,
        }),

        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
            else fallback()
            end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then luasnip.jump(-1)
            else fallback()
            end
        end, { "i", "s" }),
    })
end

return M
