if #vim.api.nvim_list_uis() == 0 then
  return {
    setup = function() end,
    setup_database_connection = function() end,
    format_sql = function() end,
  }
end

local M = {}

function M.setup(capabilities)
  vim.defer_fn(function()
    local sql_ok, lspconfig = pcall(require, "lspconfig")
    if not sql_ok then
      vim.notify("[lsp.servers.sql] nvim-lspconfig not found", vim.log.levels.WARN)
      return
    end

    -- Postgres LSP
    local pg_ok = pcall(require, "lspconfig.server_configurations.postgres_lsp")
    if pg_ok then
      pcall(function()
        lspconfig.postgres_lsp.setup({
          capabilities = capabilities,
          filetypes = { "sql", "pgsql", "plpgsql" },
          settings = {
            postgres = {
              connection = { host = "localhost", port = 5432 },
              plpgsql = { enabled = true, linting = true },
            },
          },
        })
      end)
    end

    -- SQL Server (T-SQL)
    local sqlls_ok = pcall(require, "lspconfig.server_configurations.sqlls")
    if sqlls_ok then
      pcall(function()
        lspconfig.sqlls.setup({
          capabilities = capabilities,
          filetypes = { "sql", "tsql" },
          root_dir = lspconfig.util.root_pattern(".git"),
          settings = {
            sql = {
              connections = {},
              linting = { enabled = true },
              formatting = { enabled = true },
            },
          },
        })
      end)
    end

    -- SQLs (generic, Oracle/MySQL/Postgres)
    local sqls_ok = pcall(require, "lspconfig.server_configurations.sqls")
    if sqls_ok then
      pcall(function()
        lspconfig.sqls.setup({
          capabilities = capabilities,
          filetypes = { "sql", "plsql", "oracle" },
          settings = {
            sqls = { connections = {} },
          },
        })
      end)
    end
  end, 100)
end

function M.setup_database_connection(kind, connection_config)
  local clients = vim.lsp.get_active_clients({ name = kind })
  if not clients or #clients == 0 then
    vim.notify("No SQL language server client found for: " .. tostring(kind), vim.log.levels.WARN)
    return
  end

  local client = clients[1]
  if kind == "sqls" then
    table.insert(client.config.settings.sqls.connections, connection_config)
  elseif kind == "sqlls" then
    table.insert(client.config.settings.sql.connections, connection_config)
  else
    vim.notify("Unsupported SQL LSP kind: " .. tostring(kind), vim.log.levels.WARN)
    return
  end

  vim.cmd("LspRestart " .. kind)
end

function M.format_sql()
  vim.lsp.buf.format({
    async = true,
    filter = function(client)
      return client.name == "sqlls" or client.name == "sqls" or client.name == "postgres_lsp"
    end,
  })
end

vim.api.nvim_create_user_command("SqlFormat", M.format_sql, { desc = "Format SQL code" })

vim.api.nvim_create_user_command("SqlConnect", function(opts)
  local args = vim.split(opts.args or "", "%s+")
  local kind = args[1]
  local connection_json = table.concat(vim.list_slice(args, 2), " ")

  if not kind or kind == "" or connection_json == "" then
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
  complete = function()
    return { "sqls", "sqlls" }
  end,
})

return M
