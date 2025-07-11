local M = {}

local map = vim.keymap.set
local api = vim.api
local buf = vim.lsp.buf
local diagnostic = vim.diagnostic
local g = vim.g
local fn = vim.fn
local notify = vim.notify
local inspect = vim.inspect
local b = vim.b
local lsp = vim.lsp
local log = vim.log

function M.setup_keymaps()
    api.nvim_create_autocmd("LspAttach", {
        desc = "LSP actions",
        callback = function(event)
            local opts = { buffer = event.buf, silent = true }

            -- Core navigation
            map("n", "K", buf.hover, opts)
            map("n", "gd", buf.definition, opts)
            map("n", "gD", buf.declaration, opts)
            map("n", "gi", buf.implementation, opts)
            map("n", "go", buf.type_definition, opts)
            map("n", "gr", buf.references, opts)
            map("n", "gs", buf.signature_help, opts)

            -- Telescope integration (if available)
            local has_telescope, telescope = pcall(require, "telescope.builtin")
            if has_telescope then
                -- Updated Telescope LSP function names
                map("n", "grd", telescope.lsp_definitions, opts)
                map("n", "gri", telescope.lsp_implementations, opts)
                map("n", "grr", telescope.lsp_references, opts)
                map("n", "gO", telescope.lsp_document_symbols, opts)
                map("n", "<leader>ws", telescope.lsp_workspace_symbols, opts)
            end

            -- Code actions and refactoring
            map("n", "grn", buf.rename, opts)
            map({ "n", "x" }, "gra", buf.code_action, opts)
            map("n", "<leader>ca", buf.code_action, opts)

            -- Diagnostics
            map("n", "<leader>e", diagnostic.open_float, opts)
            map("n", "[d", function() diagnostic.jump({ count = -1 }) end, opts)
            map("n", "]d", function() diagnostic.jump({ count = 1 }) end, opts)
            map("n", "<leader>q", diagnostic.setloclist, opts)

            -- Enhanced diagnostic navigation
            map("n", "[e", function() diagnostic.jump({ count = -1, severity = diagnostic.severity.ERROR }) end, opts)
            map("n", "]e", function() diagnostic.jump({ count = 1, severity = diagnostic.severity.ERROR }) end, opts)

            -- Workspace management
            map("n", "<leader>wa", buf.add_workspace_folder, opts)
            map("n", "<leader>wr", buf.remove_workspace_folder, opts)
            map("n", "<leader>wl", function() print(inspect(buf.list_workspace_folders())) end, opts)

            -- Format on save toggle
            map("n", "<leader>tf", function()
                if b.lsp_format_on_save then
                    b.lsp_format_on_save = false
                    notify("LSP format on save disabled for buffer", log.levels.INFO)
                else
                    b.lsp_format_on_save = true
                    notify("LSP format on save enabled for buffer", log.levels.INFO)
                end
            end, opts)

            -- Manual linting with F3
            map("n", "<F3>", function()
                -- Run manual linting for current buffer
                local clients = lsp.get_clients({ bufnr = event.buf })
                for _, client in ipairs(clients) do
                    if client.name == "null-ls" then
                        -- Trigger diagnostics refresh
                        lsp.buf.code_action({
                            context = { only = { "source.organizeImports", "source.fixAll" } },
                            apply = true,
                        })
                        break
                    end
                end
                -- Also refresh diagnostics
                diagnostic.reset(nil, event.buf)
                vim.defer_fn(
                    function()
                        lsp.buf_request(event.buf, "textDocument/diagnostic", {
                            textDocument = { uri = vim.uri_from_bufnr(event.buf) },
                        })
                    end,
                    100
                )
                notify("Manual linting triggered", log.levels.INFO)
            end, { desc = "Manual linting (F3)" })

            -- Client info
            map("n", "<leader>li", function()
                local clients = lsp.get_clients({ bufnr = event.buf })
                local client_names = {}
                for _, client in ipairs(clients) do
                    table.insert(client_names, client.name)
                end
                notify("LSP clients: " .. table.concat(client_names, ", "))
            end, opts)
        end,
    })
end

function M.setup_diagnostics()
    -- Enhanced diagnostic configuration
    diagnostic.config({
        severity_sort = true,
        update_in_insert = false,
        float = {
            border = "rounded",
            source = "if_many",
            header = "",
            prefix = "",
            focusable = false,
            close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
        },
        underline = {
            severity = { diagnostic.severity.ERROR, diagnostic.severity.WARN },
        },
        signs = g.have_nerd_font and {
            text = {
                [diagnostic.severity.ERROR] = "󰅚",
                [diagnostic.severity.WARN] = "󰀪",
                [diagnostic.severity.INFO] = "󰋽",
                [diagnostic.severity.HINT] = "󰌶",
            },
            linehl = {
                [diagnostic.severity.ERROR] = "DiagnosticSignError",
            },
            numhl = {
                [diagnostic.severity.ERROR] = "DiagnosticSignError",
            },
        } or {},
        virtual_text = {
            source = "if_many",
            spacing = 4,
            prefix = "●",
            severity = { min = diagnostic.severity.WARN },
            format = function(diagnostic)
                local message = diagnostic.message
                if #message > 80 then message = message:sub(1, 77) .. "..." end
                return message
            end,
        },
    })

    -- Enhanced diagnostic signs
    if g.have_nerd_font then
        local signs = {
            { name = "DiagnosticSignError", text = "󰅚", texthl = "DiagnosticSignError" },
            { name = "DiagnosticSignWarn", text = "󰀪", texthl = "DiagnosticSignWarn" },
            { name = "DiagnosticSignInfo", text = "󰋽", texthl = "DiagnosticSignInfo" },
            { name = "DiagnosticSignHint", text = "󰌶", texthl = "DiagnosticSignHint" },
        }

        for _, sign in ipairs(signs) do
            fn.sign_define(sign.name, sign)
        end
    end
end

-- Note: Completion setup is handled in your separate cmp configuration file
-- This function is kept for compatibility but doesn't duplicate your existing setup
function M.setup_completion(cmp, luasnip)
    -- Your existing cmp setup handles this
    return
end

function M.get_capabilities()
    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    -- Enhanced capabilities
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.completion.completionItem.resolveSupport = {
        properties = { "documentation", "detail", "additionalTextEdits" },
    }
    capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
    }

    return capabilities
end

function M.setup_null_ls()
    local null_ls = require("null-ls")
    local sources = {}

    -- Lua formatting
    -- if fn.executable("stylua") == 1 then table.insert(sources, null_ls.builtins.formatting.stylua) end

    -- C# formatting
    if fn.executable("csharpier") == 1 then table.insert(sources, null_ls.builtins.formatting.csharpier) end

    -- SQL formatting only (linting disabled for auto-save)
    if fn.executable("sql-formatter") == 1 then table.insert(sources, null_ls.builtins.formatting.sql_formatter) end

    if fn.executable("sqlfluff") == 1 then
        table.insert(sources, null_ls.builtins.formatting.sqlfluff)
        -- Add sqlfluff diagnostics but only for manual triggering (F3)
        table.insert(
            sources,
            null_ls.builtins.diagnostics.sqlfluff.with({
                -- Disable auto-diagnostics, only run on manual trigger
                method = null_ls.methods.DIAGNOSTICS_ON_SAVE,
                disabled_filetypes = {}, -- Enable for all filetypes but only on manual save
            })
        )
    end

    -- Additional common formatters
    if fn.executable("prettier") == 1 then table.insert(sources, null_ls.builtins.formatting.prettier) end

    if fn.executable("black") == 1 then table.insert(sources, null_ls.builtins.formatting.black) end

    if fn.executable("isort") == 1 then table.insert(sources, null_ls.builtins.formatting.isort) end

    null_ls.setup({
        sources = sources,
        -- Disable automatic diagnostics
        diagnostics_format = "#{m}",
        update_in_insert = false,
        on_attach = function(client, bufnr)
            -- Only format on save, no automatic linting
            if client.supports_method("textDocument/formatting") then
                api.nvim_create_autocmd("BufWritePre", {
                    buffer = bufnr,
                    callback = function()
                        if b.lsp_format_on_save ~= false then
                            lsp.buf.format({
                                bufnr = bufnr,
                                filter = function(c) return c.name == "null-ls" end,
                            })
                        end
                    end,
                })
            end
        end,
    })
end

function M.setup_format_keymap()
    map("n", "<leader>gf", function()
        buf.format({
            async = true,
            filter = function(client) return client.name ~= "ts_ls" end,
        })
    end, { desc = "Format with LSP/null-ls" })

    -- Format selection
    map("x", "<leader>gf", function()
        buf.format({
            async = true,
            range = {
                start = fn.getpos("'<"),
                ["end"] = fn.getpos("'>"),
            },
            filter = function(client) return client.name ~= "ts_ls" end,
        })
    end, { desc = "Format selection" })
end

-- Auto-format on save (can be toggled per buffer)
function M.setup_autoformat()
    api.nvim_create_autocmd("BufWritePre", {
        pattern = "*",
        callback = function()
            if b.lsp_format_on_save ~= false then
                buf.format({
                    async = false,
                    filter = function(client) return client.name ~= "ts_ls" end,
                })
            end
        end,
    })
end

-- Enhanced LSP UI
function M.setup_lsp_ui()
    -- Customized LSP handlers using modern approach
    lsp.handlers["textDocument/hover"] = function(_, result, ctx, config)
        config = config or {}
        config.border = config.border or "rounded"
        config.title = config.title or "Hover"

        if not result or not result.contents then return end

        local markdown_lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
        -- Use vim.split with trimempty instead of deprecated trim_empty_lines
        local content = table.concat(markdown_lines, "\n")
        markdown_lines = vim.split(content, "\n", { trimempty = true })

        if vim.tbl_isempty(markdown_lines) then return end

        return vim.lsp.util.open_floating_preview(markdown_lines, "markdown", config)
    end

    lsp.handlers["textDocument/signatureHelp"] = function(_, result, ctx, config)
        config = config or {}
        config.border = config.border or "rounded"
        config.title = config.title or "Signature Help"

        if not result or not result.signatures or vim.tbl_isempty(result.signatures) then return end

        local lines = {}
        for i, signature in ipairs(result.signatures) do
            table.insert(lines, signature.label)
            if signature.documentation then
                table.insert(lines, "")
                if type(signature.documentation) == "string" then
                    table.insert(lines, signature.documentation)
                elseif signature.documentation.value then
                    table.insert(lines, signature.documentation.value)
                end
            end
            if i < #result.signatures then table.insert(lines, "") end
        end

        return vim.lsp.util.open_floating_preview(lines, "markdown", config)
    end

    -- Enhanced progress handler
    local progress_handler = function(_, result, ctx)
        local client = lsp.get_client_by_id(ctx.client_id)
        if not client then return end

        local value = result.value
        if value.kind == "end" then
            notify(string.format("%s: %s", client.name, value.message or "Complete"), log.levels.INFO)
        elseif value.kind == "report" and value.message then
            local percentage = value.percentage and string.format(" (%.0f%%)", value.percentage) or ""
            notify(string.format("%s: %s%s", client.name, value.message, percentage), log.levels.INFO)
        end
    end

    lsp.handlers["$/progress"] = progress_handler
end

return M
