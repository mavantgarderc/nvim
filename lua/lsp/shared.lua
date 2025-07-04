local M = {}

local map = vim.keymap.set
local api = vim.api
local buf = vim.lsp.buf
local diagnostic = vim.diagnostic
local g = vim.g
local fn = vim.fn

function M.setup_keymaps()
    api.nvim_create_autocmd("LspAttach", {
        desc = "LSP actions",
        callback = function(event)
            local opts = { buffer = event.buf }
            map("n", "K", ":lua vim.lsp.buf.hover()<cr>", opts)
            map("n", "gd", ":lua vim.lsp.buf.definition()<cr>", opts)
            map("n", "grd", require("telescope.builtin").lsp_definitions, opts)
            -- map('n', 'grd', require("telescope.builtin").definitions, opts)
            map("n", "gD", ":lua vim.lsp.buf.declaration()<cr>", opts)
            map("n", "gi", ":lua vim.lsp.buf.implementation()<cr>", opts)
            map("n", "gri", require("telescope.builtin").lsp_implementations, opts)
            map("n", "go", ":lua vim.lsp.buf.type_definition()<cr>", opts)
            -- map('n', 'grr', ':lua vim.lsp.buf.references()<cr>', opts)
            -- map('n', 'grr', require("telescope.builtin").lsp_reference, opts)
            map("n", "gs", ":lua vim.lsp.buf.signature_help()<cr>", opts)
            map("n", "grn", ":lua vim.lsp.buf.rename()<cr>", opts)
            map({ "n", "x" }, "gra", ":lua vim.lsp.buf.code_action()<cr>", opts)
            -- map({ "n", "x" }, "<F3>", function()
            --     vim.lsp.buf.format({
            --         async = true,
            --         filter = function(client) return client.name ~= "ts_ls" end,
            --     })
            -- end)
            map("n", "gO", require("telescope.builtin").lsp_document_symbols, opts)
        end,
    })
end

function M.setup_diagnostics()
    diagnostic.config({
        severity_sort = true,
        float = { border = "rounded", source = "if_many" },
        underline = { severity = diagnostic.severity.ERROR },
        signs = g.have_nerd_font and {
            text = {
                [diagnostic.severity.ERROR] = "󰅚 ",
                [diagnostic.severity.WARN]  = "󰀪 ",
                [diagnostic.severity.INFO]  = "󰋽 ",
                [diagnostic.severity.HINT]  = "󰌶 ",
            },
        } or {},
        virtual_text = {
            source = "if_many",
            spacing = 2,
            format = function(diagnostic) return diagnostic.message end,
        },
    })
end

function M.setup_completion(cmp, luasnip)
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
                if luasnip.locally_jumpable(1) then luasnip.jump(1)
                else fallback()
                end end, { "i", "s" }),
            ["<C-b>"] = cmp.mapping(function(fallback)
                if luasnip.locally_jumpable(-1) then luasnip.jump(-1)
                else fallback()
                end end, { "i", "s" }),
        }),
    })
end

function M.get_capabilities()
    return require("cmp_nvim_lsp").default_capabilities()
end

function M.setup_null_ls()
    local null_ls = require("null-ls")
    local sources = {}

    if fn.executable("stylua") == 1 then
        table.insert(sources, null_ls.builtins.formatting.stylua)
    end

    if fn.executable("csharpier") == 1 then
        table.insert(sources, null_ls.builtins.formatting.csharpier)
    end

    if fn.executable("sql-formatter") == 1 then
        table.insert(sources, null_ls.builtins.formatting.sql_formatter)
    end

    if fn.executable("sqlfluff") == 1 then
        table.insert(sources, null_ls.builtins.formatting.sqlfluff)
        table.insert(sources, null_ls.builtins.diagnostics.sqlfluff)
    end

    null_ls.setup({
        sources = sources,
    })
end

function M.setup_format_keymap()
    map("n", "<leader>gf", function()
        buf.format({
            async = true,
            filter = function(client) return client.name ~= "ts_ls" end,
        })
    end, { desc = "Format with LSP/none-ls" })
end

return M
