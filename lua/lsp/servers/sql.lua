local M = {}

function M.setup(capabilities)
  -- Postgres LSP
  require("lspconfig").postgres_lsp.setup({
    capabilities = capabilities,
    filetypes = { "sql", "pgsql", "plpgsql" },
    settings = {
      postgres = {
        connection = { host = "localhost", port = 5432 },
        plpgsql = { enabled = true, linting = true },
      },
    },
  })

  -- SQL Server (T-SQL)
  require("lspconfig").sqlls.setup({
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
  })

  -- SQLs (generic, Oracle/MySQL/Postgres)
  require("lspconfig").sqls.setup({
    capabilities = capabilities,
    filetypes = { "sql", "plsql", "oracle" },
    settings = {
      sqls = { connections = {} }, -- can be populated dynamically
    },
  })
end

-- Dynamically add a DB connection for sqls or sqlls
function M.setup_database_connection(kind, connection_config)
  local client = vim.lsp.get_active_clients({ name = kind })[1]
  if client then
    if kind == "sqls" then
      table.insert(client.config.settings.sqls.connections, connection_config)
    elseif kind == "sqlls" then
      table.insert(client.config.settings.sql.connections, connection_config)
    else
      vim.notify("Unsupported SQL LSP kind: " .. tostring(kind), vim.log.levels.WARN)
      return
    end
    vim.cmd("LspRestart " .. kind)
    return
  end
  vim.notify("No SQL language server client found for: " .. tostring(kind), vim.log.levels.WARN)
end

function M.format_sql()
  vim.lsp.buf.format({
    async = true,
    filter = function(client) return client.name == "sqlls" or client.name == "sqls" or client.name == "postgres_lsp" end,
  })
end

vim.api.nvim_create_user_command("SqlFormat", function() M.format_sql() end, { desc = "Format SQL code" })

vim.api.nvim_create_user_command("SqlConnect", function(opts)
  local args = vim.split(opts.args or "", "%s+")
  local kind = args[1]
  if not kind or kind == "" then
    print("Usage: :SqlConnect <sqls|sqlls> <connection_json>")
    return
  end
  local connection_json = table.concat(vim.list_slice(args, 2), " ")
  if connection_json == "" then
    print("Usage: :SqlConnect <sqls|sqlls> <connection_json>")
    return
  end
  local ok, connection_config = pcall(vim.fn.json_decode, connection_json)
  if not ok or type(connection_config) ~= "table" then
    print("Invalid connection JSON")
    return
  end
  M.setup_database_connection(kind, connection_config)
  vim.notify("Added database connection to " .. kind, vim.log.levels.INFO)
end, {
  nargs = "+",
  desc = "Add a database connection to sqls or sqlls (usage: :SqlConnect sqls '{...}')",
  complete = function() return { "sqls", "sqlls" } end,
})

return M
