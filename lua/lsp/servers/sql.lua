local M = {}

local opts = { buffer = bufnr, silent = true }
local map = vim.keymap.set
local lsp = vim.lsp
local cmd = vim.cmd
local api = vim.api
local log = vim.log
local notify = vim.notify

function M.setup(capabilities)
    local lspconfig = require("lspconfig")

    lspconfig.sqlls.setup({
        capabilities = capabilities,
        settings = {
            sql = {
                connections = {
                    -- snippet configurations
                    -- {
                    --     name = "local_postgres",
                    --     adapter = "postgresql",
                    --     host = "localhost",
                    --     port = 5432,
                    --     user = "postgres",
                    --     database = "mydb"
                    -- },
                    -- {
                    --     name = "local_mysql",
                    --     adapter = "mysql",
                    --     host = "localhost",
                    --     port = 3306,
                    --     user = "root",
                    --     database = "mydb"
                    -- }
                },
                linting = {
                    enabled = true,
                },
                formatting = {
                    enabled = true,
                },
            },
        },
        filetypes = { "sql", "mysql", "plsql" },
        root_dir = function(fname)
            return lspconfig.util.find_git_ancestor(fname) or
                   lspconfig.util.find_node_modules_ancestor(fname) or
                   lspconfig.util.path.dirname(fname)
        end,
    })

    lspconfig.sqls.setup({
        capabilities = capabilities,
        settings = {
            sqls = {
                connections = {
                    -- PostgreSQL example
                    -- {
                    --     driver = "postgresql",
                    --     dataSourceName = "host=127.0.0.1 port=5432 user=postgres password=password dbname=postgres sslmode=disable"
                    -- },
                    -- MySQL example
                    -- {
                    --     driver = "mysql",
                    --     dataSourceName = "user:password@tcp(127.0.0.1:3306)/dbname"
                    -- },
                    -- SQLite example
                    -- {
                    --     driver = "sqlite3",
                    --     dataSourceName = "path/to/database.db"
                    -- }
                },
            },
        },
        filetypes = { "sql", "mysql" },
        on_attach = function(client, bufnr)
            map("n", "<leader>se", "<cmd>SqlsExecuteQuery<CR>", opts)
            map("v", "<leader>se", "<cmd>SqlsExecuteQuery<CR>", opts)
            map("n", "<leader>sr", "<cmd>SqlsExecuteQueryVertical<CR>", opts)
            map("v", "<leader>sr", "<cmd>SqlsExecuteQueryVertical<CR>", opts)
            map("n", "<leader>st", "<cmd>SqlsShowTables<CR>", opts)
            map("n", "<leader>sd", "<cmd>SqlsShowDatabases<CR>", opts)
            map("n", "<leader>sc", "<cmd>SqlsShowConnections<CR>", opts)
        end,
    })

    lspconfig.postgres_lsp.setup({
        capabilities = capabilities,
        -- PostgreSQL specific settings
        settings = {
            postgres = {
                connection = {
                    host = "localhost",
                    port = 5432,
                },
                plpgsql = {
                    enabled = true,
                    linting = true,
                },
            },
        },
        filetypes = { "sql", "pgsql", "plpgsql" },
    })
end

function M.setup_database_connection(connection_config)
    local sqls_config = lsp.get_active_clients({ name = "sqls" })[1]
    if sqls_config then
        table.insert(sqls_config.config.settings.sqls.connections, connection_config)
        cmd("LspRestart sqls")
    end
end

function M.format_sql()
    lsp.buf.format({
        async = true,
        filter = function(client)
            return client.name == "sqlls" or client.name == "sqls"
        end,
    })
end

api.nvim_create_user_command("SqlFormat", function()
    M.format_sql()
end, { desc = "Format SQL code" })

api.nvim_create_user_command("SqlConnect", function(opts)
    local connection_name = opts.args
    if connection_name == "" then
        print("Usage: :SqlConnect <connection_name>")
        return
    end

    notify("Connecting to database: " .. connection_name, log.levels.INFO)
end, {
    nargs = 1,
    desc = "Connect to a database",
    complete = function()
        return { "local_postgres", "local_mysql", "production_db" }
    end
})

return M
