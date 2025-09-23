local M = {}

local lsp = vim.lsp
local api = vim.api
local log = vim.log
local notify = vim.notify
local cmd = vim.cmd
local fn = vim.fn
local split = vim.split
local list_slice = vim.list_slice

function M.setup(capabilities)
  -- Postgres LSP
  lsp.config["postgres_lsp"] = {
    capabilities = capabilities,
    filetypes = { "sql", "pgsql", "plpgsql" },
    settings = {
      postgres = {
        connection = { host = "localhost", port = 5432 },
        plpgsql = { enabled = true, linting = true },
      },
    },
  }

  -- SQL Server (T-SQL)
  lsp.config["sqlls"] = {
    capabilities = capabilities,
    filetypes = { "sql", "tsql" },
    root_markers = { ".git" },
    settings = {
      sql = {
        connections = {}, -- can be populated dynamically
        linting = { enabled = true },
        formatting = { enabled = true },
      },
    },
  }

  -- SQLs (generic, Oracle/MySQL/Postgres)
  lsp.config["sqls"] = {
    capabilities = capabilities,
    filetypes = { "sql", "plsql", "oracle" },
    settings = {
      sqls = { connections = {} }, -- can be populated dynamically
    },
  }

end

-- Dynamically add a DB connection for sqls or sqlls
function M.setup_database_connection(kind, connection_config)
  local client = lsp.get_active_clients({ name = kind })[1]
  if client then
    if kind == "sqls" then
      table.insert(client.config.settings.sqls.connections, connection_config)
    elseif kind == "sqlls" then
      table.insert(client.config.settings.sql.connections, connection_config)
    else
      notify("Unsupported SQL LSP kind: " .. tostring(kind), log.levels.WARN)
      return
    end
    cmd("LspRestart " .. kind)
    return
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
  complete = function() return { "sqls", "sqlls" } end,
})

return M
