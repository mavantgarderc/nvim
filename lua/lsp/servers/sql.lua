local M = {}

local map = vim.keymap.set
local lsp = vim.lsp
local cmd = vim.cmd
local api = vim.api
local log = vim.log
local notify = vim.notify
local tbl_extend = vim.tbl_extend
local fn = vim.fn
local split = vim.split
local list_slice = vim.list_slice

function M.setup(capabilities)
  local lspconfig = require("lspconfig")

  -- PL/pgSQL & general SQL: postgres_lsp
  lspconfig.postgres_lsp.setup({
    capabilities = capabilities,
    settings = {
      postgres = {
        connection = {
          host = "localhost",
          port = 5432,
          -- user/password/database can be prompted/extended later
        },
        plpgsql = {
          enabled = true,
          linting = true,
        },
      },
    },
    filetypes = { "sql", "pgsql", "plpgsql" },
  })

  -- T-SQL: sqlls for best SQL Server support
  lspconfig.sqlls.setup({
    capabilities = capabilities,
    settings = {
      sql = {
        connections = {
          -- Uncomment and configure for MS SQL:
          -- {
          --     name = "local_mssql",
          --     adapter = "mssql",
          --     host = "localhost",
          --     port = 1433,
          --     user = "sa",
          --     password = "your_password",
          --     database = "master"
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
    filetypes = { "sql", "tsql" },
    root_dir = function(fname)
      return lspconfig.util.find_git_ancestor(fname) or
          lspconfig.util.path.dirname(fname)
    end,
  })

  -- PL/SQL (Oracle): sqls is closest, but limited
  lspconfig.sqls.setup({
    capabilities = capabilities,
    settings = {
      sqls = {
        connections = {
          -- Add Oracle, PostgreSQL, or MySQL connection strings if you use them
          -- {
          --     driver = "oracle",
          --     dataSourceName = "user/password@localhost:1521/XEPDB1"
          -- },
        },
      },
    },
    filetypes = { "sql", "plsql", "oracle" },
  })
end

-- Dynamically add a DB connection for sqls or sqlls
function M.setup_database_connection(kind, connection_config)
  if kind == "sqls" then
    local client = lsp.get_active_clients({ name = "sqls" })[1]
    if client then
      table.insert(client.config.settings.sqls.connections, connection_config)
      cmd("LspRestart sqls")
      return
    end
  elseif kind == "sqlls" then
    local client = lsp.get_active_clients({ name = "sqlls" })[1]
    if client then
      table.insert(client.config.settings.sql.connections, connection_config)
      cmd("LspRestart sqlls")
      return
    end
  else
    notify("Unsupported SQL LSP kind: " .. tostring(kind), log.levels.WARN)
  end
  notify("No SQL language server client found for: " .. tostring(kind), log.levels.WARN)
end

function M.format_sql()
  lsp.buf.format({
    async = true,
    filter = function(client)
      return client.name == "sqlls" or client.name == "sqls" or client.name == "postgres_lsp"
    end,
  })
end

api.nvim_create_user_command("SqlFormat", function()
  M.format_sql()
end, { desc = "Format SQL code" })

api.nvim_create_user_command("SqlConnect", function(opts)
  local args = split(opts.args or "", "%s+")
  local kind = args[1]
  if not kind or kind == "" then
    print("Usage: :SqlConnect <sqls|sqlls> <connection_json>")
    return
  end
  local connection_json = table.concat(list_slice(args, 2), " ")
  if connection_json == "" then
    print("Usage: :SqlConnect <sqls|sqlls> <connection_json>")
    return
  end
  local ok, connection_config = pcall(fn.json_decode, connection_json)
  if not ok or type(connection_config) ~= "table" then
    print("Invalid connection JSON")
    return
  end
  M.setup_database_connection(kind, connection_config)
  notify("Added database connection to " .. kind, log.levels.INFO)
end, {
  nargs = "+",
  desc = "Add a database connection to sqls or sqlls (usage: :SqlConnect sqls '{...}')",
  complete = function()
    return { "sqls", "sqlls" }
  end
})

return M
