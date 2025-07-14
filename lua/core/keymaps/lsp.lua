local map = vim.keymap.set
local api = vim.api
local buf = vim.lsp.buf
local diagnostic = vim.diagnostic
local g = vim.g
local fn = vim.fn
local notify = vim.notify
local inspect = vim.inspect
local b = vim.b
local bo = vim.bo
local lsp = vim.lsp
local log = vim.log
local defer_fn = vim.defer_fn
local uri_from_bufnr = vim.uri_from_bufnr
local tbl_extend = vim.tbl_extend

local M = {}

function M.setup_lsp_keymaps()
    api.nvim_create_autocmd("LspAttach", {
        desc = "LSP actions",
        callback = function(event)
            local opts = { buffer = event.buf, silent = true }

            map("n", "<leader>K",  buf.hover,           opts)
            map("n", "<leader>gd", buf.definition,      opts)
            map("n", "<leader>gD", buf.declaration,     opts)
            map("n", "<leader>gi", buf.implementation,  opts)
            map("n", "<leader>go", buf.type_definition, opts)
            map("n", "<leader>gr", buf.references,      opts)
            map("n", "<leader>gs", buf.signature_help,  opts)

            map("n", "<leader>grn", buf.rename, opts)
            map("n", "<leader>ca",  buf.code_action, opts)
            map({ "n", "x" }, "<leader>gra", buf.code_action, opts)

            map("n", "<leader>e",  diagnostic.open_float, opts)
            map("n", "<leader>q",  diagnostic.setloclist, opts)
            map("n", "<leader>[d", function() diagnostic.jump({ count = -1 }) end, opts)
            map("n", "<leader>]d", function() diagnostic.jump({ count =  1 }) end, opts)

            map("n", "<leader>[e", function()diagnostic.jump({ count = -1, severity = diagnostic.severity.ERROR }) end, opts)
            map("n", "<leader>]e", function()diagnostic.jump({ count =  1, severity = diagnostic.severity.ERROR }) end, opts)

            map("n", "<leader>wa", buf.add_workspace_folder, opts)
            map("n", "<leader>wr", buf.remove_workspace_folder, opts)
            map("n", "<leader>wl", function()
                print(inspect(buf.list_workspace_folders()))
            end, opts)

            local has_telescope, telescope = pcall(require, "telescope.builtin")
            if has_telescope then
                map("n", "<leader>li", telescope.lsp_implementations,   { desc = "LSP implementations"  })
                map("n", "<leader>lr", telescope.lsp_references,        { desc = "LSP references"       })
                map("n", "<leader>ld", telescope.lsp_definitions,       { desc = "LSP definitions"      })
                map("n", "<leader>lt", telescope.lsp_type_definitions,  { desc = "LSP type definitions" })
                map("n", "<leader>ls", telescope.lsp_document_symbols,  { desc = "Document symbols"     })
                map("n", "<leader>le", telescope.diagnostics,           { desc = "Diagnostics"          })
                map("n", "<leader>lw", telescope.lsp_workspace_symbols, { desc = "Workspace symbols"    })
            end

            -- toggle auto-lint
            b.lsp_format_on_save = false
            map("n", "<leader>tf", function()
                if b.lsp_format_on_save then
                    b.lsp_format_on_save = false
                    notify("LSP format on save disabled for buffer", log.levels.INFO)
                else
                    b.lsp_format_on_save = true
                    notify("LSP format on save enabled for buffer", log.levels.INFO)
                end
            end, opts)

            -- lint
            map("n", "<F3>", function()
                local clients = lsp.get_clients({ bufnr = event.buf })
                for _, client in ipairs(clients) do
                    if client.name == "null-ls" then
                        lsp.buf.code_action({ context = {
                            only = { "source.organizeImports", "source.fixAll" },
                            diagnostics = diagnostic.get(event.buf), }, apply = true, })
                        break
                    end
                end
                diagnostic.reset(nil, event.buf) defer_fn( function()
                    lsp.buf_request(event.buf, "textDocument/diagnostic", {
                        textDocument = { uri = uri_from_bufnr(event.buf) }, })
                end, 100) notify("Manual linting triggered", log.levels.INFO)
            end, { desc = "Manual linting (F3)" })

            -- map("n", "<leader>li", function()
            --     local clients = lsp.get_clients({ bufnr = event.buf })
            --     local client_names = {}
            --     for _, client in ipairs(clients) do
            --         table.insert(client_names, client.name)
            --     end
            --     notify("LSP clients: " .. table.concat(client_names, ", "))
            -- end, opts)

            -- SQL-specific keymaps (buffer-local, only present if SQL LSP attached)
            local ft = bo[event.buf].filetype
            -- Common keymapsefor all SQL LSPs
            if ft == "sql" or ft == "plsql" or ft == "oracle" or ft == "tsql" or ft == "pgsql" then
                map("n", "<leader>sf", function()
                    lsp.buf.format({ async = true })
                end, tbl_extend("force", opts, { desc = "Format SQL" }))

                map("n", "<leader>sk", function()
                    lsp.buf.hover()
                end, tbl_extend("force", opts, { desc = "Show info (hover)" }))

            end

            -- sqls-specific
            local clients = lsp.get_clients({ bufnr = event.buf })
            for _, client in ipairs(clients) do
                if client.name == "sqls" then
                    map("n", "<leader>se", ":SqlsExecuteQuery<CR>",         opts)
                    map("n", "<leader>sr", ":SqlsExecuteQueryVertical<CR>", opts)
                    map("n", "<leader>st", ":SqlsShowTables<CR>",           opts)
                    map("n", "<leader>sd", ":SqlsShowDatabases<CR>",        opts)
                    map("n", "<leader>sc", ":SqlsShowConnections<CR>",      opts)
                    map("v", "<leader>se", ":SqlsExecuteQuery<CR>",         opts)
                    map("v", "<leader>sr", ":SqlsExecuteQueryVertical<CR>", opts)
                    break
                end
            end
        end,
    })
end

return M
