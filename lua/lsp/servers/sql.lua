local M = {}

local map = vim.keymap.set
local lsp = vim.lsp
local cmd = vim.cmd
local api = vim.api
local log = vim.log
local notify = vim.notify
local fn = vim.fn
local split = vim.split
local list_slice = vim.list_slice

function M.setup(capabilities)
  -- Postgres LSP
  vim.lsp.config["postgres_lsp"] = {
    capabilities = capabilities,
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
  }

  -- SQL Server (T-SQL)
  vim.lsp.config["sqlls"] = {
    capabilities = capabilities,
    settings = {
      sql = {
        connections = {
          -- Example:
          -- {
          --   name = "local_mssql",
          --   adapter = "mssql",
          --   host = "localhost",
          --   port = 1433,
          --   user = "sa",
          --   password = "your_password",
          --   database = "master",
          -- }
        },
        linting = { enabled = true },
        formatting = { enabled = true },
      },
    },
    filetypes = { "sql", "tsql" },
    root_dir = function(fname)
      return vim.fs.root(fname, { ".git" }) or vim.fs.dirname(fname)
    end,
  }

  -- SQLs (generic, Oracle/MySQL/Postgres)
  vim.lsp.config["sqls"] = {
    capabilities = capabilities,
    settings = {
      sqls = {
        connections = {
          -- Example Oracle connection:
          -- {
          --   driver = "oracle",
          --   dataSourceName = "user/password@localhost:1521/XEPDB1"
          -- }
        },
      },
    },
    filetypes = { "sql", "plsql", "oracle" },
  }

  -- Start all SQL servers
  vim.lsp.start(vim.lsp.config["postgres_lsp"])
  vim.lsp.start(vim.lsp.config["sqlls"])
  vim.lsp.start(vim.lsp.config["sqls"])
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
  end,
})

return M
