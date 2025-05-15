local lsp = require("lsp-zero")
lsp.preset("recommended")

lsp.ensure_install({
    "tsserver",
    "eslint",
    "sumneko_lua",
    "pyright",
    "omnisharp",
})

local cmp = require("cmp")
local cmp_select = { behavior = cmp.SelectBehavior.Select }

local cmp_mappings = lsp.defaults.cmp_mappings({
  ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
  ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
  ["<C-y>"] = cmp.mapping.confirm({ select = true })
})

lsp.set_preferences ({
    sign_icons = { }
})

lsp.on_attach(function(client, bufnr)
        print("help")
    local opts = { buffer = bufnr, remap = false }
    local cks = vim.keymap.set

    cks("n", "gd", function() vim.lsp.buf.definition() end, opts)
    cks("n", "K", function() vim.lsp.buf.hover() end, opts)
    cks("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
    cks("n", "<leader>vd", function() vim.diagnostics.open_float() end, opts)
    cks("n", "[d", function() vim.diagnostics.goto_next() end, opts)
    cks("n", "]d", function() vim.diagnostics.goto_prev() end, opts)
    cks("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
    cks("n", "<leawder>vrr", function() vim.lsp.buf.references() end, opts)
    cks("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
    cks("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

lsp.setup()
