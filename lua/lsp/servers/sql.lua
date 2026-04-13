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
	vim.lsp.enable("flux_lsp")
end

-- ── Dynamic DB Connection Injection ───────────────────────────────
function M.setup_database_connection(kind, connection_config)
	local clients = vim.lsp.get_clients({ name = kind })
	if not clients or #clients == 0 then
		vim.notify("No SQL client found: " .. tostring(kind), vim.log.levels.WARN)
		return false
	end

	local client = clients[1]

	if kind == "sqls" then
		client.config.settings.sqls.connections = client.config.settings.sqls.connections or {}
		table.insert(client.config.settings.sqls.connections, connection_config)
	elseif kind == "sqlls" then
		client.config.settings.sql.connections = client.config.settings.sql.connections or {}
		table.insert(client.config.settings.sql.connections, connection_config)
	elseif kind == "postgres_lsp" then
		-- postgres_lsp uses a single connection, overwrite
		client.config.settings.postgres.connection = connection_config
	else
		vim.notify("Unsupported SQL LSP kind: " .. tostring(kind), vim.log.levels.WARN)
		return false
	end

	-- Notify the server of the config change, then restart
	client:notify("workspace/didChangeConfiguration", { settings = client.config.settings })
	vim.lsp.stop_client(client.id)
	vim.defer_fn(function()
		vim.lsp.enable(kind)
	end, 200)

	return true
end

-- ── Format helper ─────────────────────────────────────────────────
local sql_server_names = { "sqlls", "sqls", "postgres_lsp" }

function M.format_sql(bufnr)
	vim.lsp.buf.format({
		bufnr = bufnr,
		async = true,
		filter = function(client)
			return vim.tbl_contains(sql_server_names, client.name)
		end,
	})
end

-- ── Extender (micro-plugin) ──────────────────────────────────────
-- Fires per-buffer on every LspAttach for any SQL-family server
function M.extend(client, bufnr)
	local opts = { buffer = bufnr, silent = true }

	-- Guard: only set up once per buffer (first SQL server wins)
	if vim.b[bufnr]._sql_extend_done then
		return
	end
	vim.b[bufnr]._sql_extend_done = true

	-- ── Keymaps ───────────────────────────────────────────────────

	-- Format
	vim.keymap.set("n", "<leader>sf", function()
		M.format_sql(bufnr)
	end, vim.tbl_extend("force", opts, { desc = "Format SQL" }))

	-- Show active SQL connections
	vim.keymap.set("n", "<leader>sc", function()
		local lines = {}
		for _, name in ipairs(sql_server_names) do
			local clients = vim.lsp.get_clients({ bufnr = bufnr, name = name })
			for _, c in ipairs(clients) do
				local conns
				if name == "sqls" then
					conns = (c.config.settings.sqls or {}).connections or {}
				elseif name == "sqlls" then
					conns = (c.config.settings.sql or {}).connections or {}
				elseif name == "postgres_lsp" then
					local pg = (c.config.settings.postgres or {}).connection
					conns = pg and { pg } or {}
				end
				table.insert(lines, string.format("── %s (%d conn) ──", name, #conns))
				for i, conn in ipairs(conns) do
					table.insert(lines, string.format("  %d. %s", i, vim.inspect(conn, { newline = " ", indent = "" })))
				end
			end
		end
		if #lines == 0 then
			table.insert(lines, "No active SQL servers on this buffer")
		end
		vim.lsp.util.open_floating_preview(lines, "", {
			border = "rounded",
			title = " SQL Connections ",
			title_pos = "center",
		})
	end, vim.tbl_extend("force", opts, { desc = "Show SQL connections" }))

	-- Quick connect (interactive)
	vim.keymap.set("n", "<leader>sC", function()
		vim.ui.select({ "sqls", "sqlls", "postgres_lsp" }, { prompt = "Target server:" }, function(kind)
			if not kind then
				return
			end
			vim.ui.input({ prompt = "Host (default localhost): " }, function(host)
				host = (host and host ~= "") and host or "localhost"
				vim.ui.input({ prompt = "Port: " }, function(port)
					port = tonumber(port)
					if not port then
						vim.notify("Invalid port", vim.log.levels.ERROR)
						return
					end
					vim.ui.input({ prompt = "Database name: " }, function(dbname)
						if not dbname or dbname == "" then
							vim.notify("Database name required", vim.log.levels.ERROR)
							return
						end
						vim.ui.input({ prompt = "User (default postgres): " }, function(user)
							user = (user and user ~= "") and user or "postgres"

							local conn
							if kind == "postgres_lsp" then
								conn = { host = host, port = port, dbname = dbname, user = user }
							else
								-- sqls / sqlls style
								conn = {
									driver = "postgresql",
									dataSourceName = string.format(
										"host=%s port=%d user=%s dbname=%s sslmode=disable",
										host,
										port,
										user,
										dbname
									),
								}
							end

							if M.setup_database_connection(kind, conn) then
								vim.notify(
									string.format("Connected %s → %s@%s:%d/%s", kind, user, host, port, dbname),
									vim.log.levels.INFO
								)
							end
						end)
					end)
				end)
			end)
		end)
	end, vim.tbl_extend("force", opts, { desc = "Connect to database (interactive)" }))

	-- Switch between SQL servers active on this buffer
	vim.keymap.set("n", "<leader>ss", function()
		local active = vim.lsp.get_clients({ bufnr = bufnr })
		local sql_clients = vim.tbl_filter(function(c)
			return vim.tbl_contains(sql_server_names, c.name)
		end, active)

		if #sql_clients == 0 then
			vim.notify("No SQL servers attached", vim.log.levels.WARN)
			return
		end

		local names = vim.tbl_map(function(c)
			return c.name
		end, sql_clients)

		vim.ui.select(names, { prompt = "Primary SQL server for formatting:" }, function(choice)
			if not choice then
				return
			end
			-- Move chosen server to front of filter priority
			vim.b[bufnr]._sql_primary = choice
			vim.notify("Primary SQL server: " .. choice, vim.log.levels.INFO)
		end)
	end, vim.tbl_extend("force", opts, { desc = "Select primary SQL server" }))

	-- Execute selection / current statement (sqls-specific)
	vim.keymap.set("v", "<leader>se", function()
		local clients = vim.lsp.get_clients({ bufnr = bufnr, name = "sqls" })
		if #clients == 0 then
			vim.notify("sqls not attached — execute requires sqls", vim.log.levels.WARN)
			return
		end
		clients[1]:request("workspace/executeCommand", {
			command = "executeQuery",
			arguments = { vim.uri_from_bufnr(bufnr) },
		}, function(err, result)
			if err then
				vim.notify("Query error: " .. tostring(err.message), vim.log.levels.ERROR)
				return
			end
			if result then
				local lines = vim.split(result, "\n")
				vim.lsp.util.open_floating_preview(lines, "", {
					border = "rounded",
					title = " Query Result ",
					title_pos = "center",
				})
			end
		end, bufnr)
	end, vim.tbl_extend("force", opts, { desc = "Execute SQL selection (sqls)" }))

	-- ── Buffer-local commands ─────────────────────────────────────

	vim.api.nvim_buf_create_user_command(bufnr, "SqlFormat", function()
		M.format_sql(bufnr)
	end, { desc = "Format SQL code" })

	vim.api.nvim_buf_create_user_command(bufnr, "SqlConnect", function(cmd_opts)
		local args = vim.split(cmd_opts.args or "", "%s+")
		local kind = args[1]
		local connection_json = table.concat(vim.list_slice(args, 2), " ")

		if not kind or kind == "" or connection_json == "" then
			vim.notify("Usage: :SqlConnect <sqls|sqlls|postgres_lsp> <connection_json>", vim.log.levels.WARN)
			return
		end

		local ok, connection_config = pcall(vim.fn.json_decode, connection_json)
		if not ok or type(connection_config) ~= "table" then
			vim.notify("Invalid connection JSON", vim.log.levels.ERROR)
			return
		end

		if M.setup_database_connection(kind, connection_config) then
			vim.notify("Added database connection to " .. kind, vim.log.levels.INFO)
		end
	end, {
		nargs = "+",
		desc = "Add a DB connection (:SqlConnect sqls '{...}')",
		complete = function()
			return { "sqls", "sqlls", "postgres_lsp" }
		end,
	})
end

return M
