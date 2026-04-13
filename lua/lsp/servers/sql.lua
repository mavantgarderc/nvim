local M = {}

function M.setup(capabilities)
	if #vim.api.nvim_list_uis() == 0 then
		return
	end

	-- Postgres LSP
	-- ----------------------------
	vim.lsp.config("postgres_lsp", {
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
	-- ----------------------------
	vim.lsp.config("sqlls", {
		capabilities = capabilities,
		filetypes = { "sql", "tsql" },
		root_dir = vim.fs.root(0, { ".git" }),
		settings = {
			sql = {
				connections = {},
				linting = { enabled = true },
				formatting = { enabled = true },
			},
		},
	})

	vim.lsp.config("flux_lsp", {
		capabilities = capabilities,
		filetypes = { "flux" },
		settings = {
			flux = {
				features = {
					linting = true,
					completion = true,
					format = true,
					snippets = true,
				},
			},
		},
		on_attach = function(client, _)
			client.server_capabilities.documentFormattingProvider = false
		end,
	})
	vim.lsp.enable("flux_lsp") -- only when filetype matched

	-- SQLs (generic SQL langserver)
	-- ----------------------------
	vim.lsp.config("sqls", {
		capabilities = capabilities,
		filetypes = { "sql", "plsql", "oracle" },

		settings = {
			sqls = {
				connections = {},
			},
		},
	})

	vim.lsp.enable("postgres_lsp")
	vim.lsp.enable("sqlls")
	vim.lsp.enable("sqls")
end

-- Dynamic DB Connection Injection
-- --------------------------------------
function M.setup_database_connection(kind, connection_config)
	local clients = vim.lsp.get_active_clients({ name = kind })
	if not clients or #clients == 0 then
		vim.notify("No SQL client found: " .. tostring(kind), vim.log.levels.WARN)
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

	vim.lsp.stop_client(client.id)
	vim.lsp.enable(kind)
end

-- SQL Formatter
-- --------------------------------------
function M.format_sql()
	vim.lsp.buf.format({
		async = true,
		filter = function(client)
			return client.name == "sqlls" or client.name == "sqls" or client.name == "postgres_lsp"
		end,
	})
end

vim.api.nvim_create_user_command("SqlFormat", M.format_sql, {
	desc = "Format SQL code",
})

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
	desc = "Add a DB connection (:SqlConnect sqls '{...}')",
	complete = function()
		return { "sqls", "sqlls" }
	end,
})

return M
