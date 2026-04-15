local map = vim.keymap.set
local buff = vim.lsp.buf

local M = {}
local setup_done = false

local function has_keymap(mode, lhs, bufnr)
	local current = vim.api.nvim_get_current_buf()
	if bufnr then
		vim.api.nvim_set_current_buf(bufnr)
	end

	local ok, keymap = pcall(vim.fn.maparg, lhs, mode, false, true)

	if bufnr and current ~= bufnr then
		vim.api.nvim_set_current_buf(current)
	end

	return ok and type(keymap) == "table" and not vim.tbl_isempty(keymap)
end

local function map_if_absent(modes, lhs, rhs, opts)
	local mode_list = type(modes) == "table" and modes or { modes }
	local bufnr = opts and opts.buffer or nil

	for _, mode in ipairs(mode_list) do
		if not has_keymap(mode, lhs, bufnr) then
			map(mode, lhs, rhs, opts)
		end
	end
end

local function telescope_call(method, fallback)
	return function()
		local ok, builtin = pcall(require, "telescope.builtin")
		if ok and type(builtin[method]) == "function" then
			builtin[method]()
			return
		end

		if fallback then
			fallback()
			return
		end

		vim.notify("Telescope is not available", vim.log.levels.WARN)
	end
end

local function focus_current_diagnostics_package()
	local fname = vim.api.nvim_buf_get_name(0)
	local root = require("lsp.monorepo").find_monorepo_root(fname) or vim.fn.getcwd()
	local pkg = require("lsp.monorepo").find_package_name(fname, root) or "."
	require("lsp.diagnostics").focus(pkg)
end

local function search_symbol_under_cursor()
	require("lsp.symbol_index").search(vim.fn.expand("<cword>"))
end

function M.setup()
	if setup_done then
		return
	end

	require("lsp.toggle").setup()
	require("lsp.info").setup()
	require("lsp.analytics").setup()

	map_if_absent("n", "<leader>lh", ":LspHealth<CR>", { desc = "LSP health dashboard" })
	map_if_absent("n", "<leader>lp", ":LspProgress<CR>", { desc = "LSP progress overview" })
	map_if_absent("n", "<leader>lI", ":LspInfo<CR>", { desc = "LSP server info" })
	map_if_absent("n", "<leader>la", ":LspAnalytics<CR>", { desc = "LSP analytics" })
	map_if_absent("n", "<leader>kp", ":LspHoverPin<CR>", { desc = "Pin hover window" })
	map_if_absent("n", "<leader>ku", ":LspHoverUnpin<CR>", { desc = "Unpin hover window" })
	map_if_absent("n", "<leader>ci", ":InlayToggle<CR>", { desc = "Toggle inlay hints" })
	map_if_absent("n", "<leader>cl", ":LensRun<CR>", { desc = "Run codelens at cursor" })
	map_if_absent("n", "<leader>cL", ":LensToggle<CR>", { desc = "Toggle codelens" })
	map_if_absent("n", "<leader>rn", ":Rename<CR>", { desc = "Smart rename" })
	map_if_absent("n", "<leader>rN", ":RenameQuick<CR>", { desc = "Quick rename" })
	map_if_absent("n", "<leader>ru", ":RenameUndo<CR>", { desc = "Undo rename" })
	map_if_absent("n", "<leader>rh", ":RenameHistory<CR>", { desc = "Rename history" })
	map_if_absent("n", "<leader>ri", ":RenameSummary<CR>", { desc = "Rename summary" })
	map_if_absent("n", "grr", ":LspRefFind<CR>", { desc = "Find references" })
	map_if_absent("n", "grs", ":LspRefSummary<CR>", { desc = "Reference summary" })
	map_if_absent("n", "<leader>dS", ":DiagSummary<CR>", { desc = "Diagnostics summary" })
	map_if_absent("n", "<leader>ds", focus_current_diagnostics_package, { desc = "Current package diagnostics" })
	map_if_absent("n", "<leader>dp", ":DiagPicker<CR>", { desc = "Diagnostics picker" })
	map_if_absent("n", "<leader>sS", ":SymbolIndex<CR>", { desc = "Workspace symbol index" })
	map_if_absent("n", "<leader>ss", search_symbol_under_cursor, { desc = "Search symbol under cursor" })

	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("LspKeymaps", { clear = true }),
		desc = "LSP actions",
		callback = function(event)
			local bufnr = event.buf
			local opts = { buffer = bufnr, silent = true }

			map_if_absent("n", "<leader>K", ":LspHover<CR>", vim.tbl_extend("force", opts, { desc = "LSP hover" }))
			map_if_absent(
				"n",
				"<leader>gd",
				buff.definition,
				vim.tbl_extend("force", opts, { desc = "LSP definition" })
			)
			map_if_absent(
				"n",
				"<leader>gD",
				buff.declaration,
				vim.tbl_extend("force", opts, { desc = "LSP declaration" })
			)
			map_if_absent(
				"n",
				"<leader>gi",
				":LspImplementation<CR>",
				vim.tbl_extend("force", opts, { desc = "LSP implementations" })
			)
			map_if_absent(
				"n",
				"<leader>go",
				":LspTypeDefinition<CR>",
				vim.tbl_extend("force", opts, { desc = "LSP type definition" })
			)
			map_if_absent(
				"n",
				"<leader>gp",
				":LspTypePeek<CR>",
				vim.tbl_extend("force", opts, { desc = "Peek type definition" })
			)
			map_if_absent(
				"n",
				"<leader>gr",
				":LspRefFind<CR>",
				vim.tbl_extend("force", opts, { desc = "LSP references" })
			)
			map_if_absent(
				"n",
				"<leader>gs",
				buff.signature_help,
				vim.tbl_extend("force", opts, { desc = "LSP signature help" })
			)

			map_if_absent("n", "<leader>grn", buff.rename, vim.tbl_extend("force", opts, { desc = "LSP rename" }))
			map_if_absent(
				"n",
				"<leader>ca",
				":CodeAction<CR>",
				vim.tbl_extend("force", opts, { desc = "Code actions" })
			)
			map_if_absent(
				"v",
				"<leader>ca",
				buff.code_action,
				vim.tbl_extend("force", opts, { desc = "Range code actions" })
			)
			map_if_absent(
				"n",
				"<leader>gra",
				":CodeActionTelescope<CR>",
				vim.tbl_extend("force", opts, { desc = "Code actions (picker)" })
			)
			map_if_absent(
				"x",
				"<leader>gra",
				buff.code_action,
				vim.tbl_extend("force", opts, { desc = "Range code actions" })
			)

			map_if_absent(
				"n",
				"<leader>e",
				vim.diagnostic.open_float,
				vim.tbl_extend("force", opts, { desc = "Line diagnostics" })
			)
			map_if_absent(
				"n",
				"<leader>q",
				vim.diagnostic.setloclist,
				vim.tbl_extend("force", opts, { desc = "Populate loclist" })
			)
			map_if_absent("n", "<leader>[d", function()
				vim.diagnostic.jump({ count = -1 })
			end, vim.tbl_extend("force", opts, { desc = "Previous diagnostic" }))
			map_if_absent("n", "<leader>]d", function()
				vim.diagnostic.jump({ count = 1 })
			end, vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))

			map_if_absent("n", "<leader>[e", function()
				vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR })
			end, vim.tbl_extend("force", opts, { desc = "Previous error" }))
			map_if_absent("n", "<leader>]e", function()
				vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR })
			end, vim.tbl_extend("force", opts, { desc = "Next error" }))

			map_if_absent(
				"n",
				"<leader>wa",
				buff.add_workspace_folder,
				vim.tbl_extend("force", opts, { desc = "Add workspace folder" })
			)
			map_if_absent(
				"n",
				"<leader>wr",
				buff.remove_workspace_folder,
				vim.tbl_extend("force", opts, { desc = "Remove workspace folder" })
			)
			map_if_absent("n", "<leader>wl", function()
				print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
			end, vim.tbl_extend("force", opts, { desc = "List workspace folders" }))

			map_if_absent(
				"n",
				"<leader>li",
				":LspImplementation<CR>",
				vim.tbl_extend("force", opts, { desc = "LSP implementations" })
			)
			map_if_absent(
				"n",
				"<leader>lr",
				":LspRefFind<CR>",
				vim.tbl_extend("force", opts, { desc = "LSP references" })
			)
			map_if_absent(
				"n",
				"<leader>ld",
				telescope_call("lsp_definitions", buff.definition),
				vim.tbl_extend("force", opts, { desc = "LSP definitions" })
			)
			map_if_absent(
				"n",
				"<leader>lt",
				":LspTypePeek<CR>",
				vim.tbl_extend("force", opts, { desc = "Peek type definition" })
			)
			map_if_absent(
				"n",
				"<leader>ls",
				telescope_call("lsp_document_symbols"),
				vim.tbl_extend("force", opts, { desc = "Document symbols" })
			)
			map_if_absent(
				"n",
				"<leader>le",
				telescope_call("diagnostics"),
				vim.tbl_extend("force", opts, { desc = "Diagnostics picker" })
			)
			map_if_absent(
				"n",
				"<leader>lw",
				":LspWorkspaceSymbol<CR>",
				vim.tbl_extend("force", opts, { desc = "Workspace symbols" })
			)

			map_if_absent(
				"n",
				"<leader>fs",
				":LspWorkspaceSymbol<CR>",
				vim.tbl_extend("force", opts, { desc = "Workspace symbol search" })
			)
			map_if_absent(
				"n",
				"<leader>fS",
				telescope_call("lsp_dynamic_workspace_symbols"),
				vim.tbl_extend("force", opts, {
					desc = "Dynamic workspace symbols",
				})
			)

			map_if_absent("n", "<leader>lL", function()
				local ok, builtin = pcall(require, "telescope.builtin")
				if not ok then
					vim.notify("Telescope is not available", vim.log.levels.WARN)
					return
				end
				builtin.find_files({
					cwd = vim.fn.stdpath("cache"),
					prompt_title = "LSP Logs",
					find_command = { "rg", "--files", "--glob", "lsp.log" },
				})
			end, vim.tbl_extend("force", opts, { desc = "Open LSP log" }))

			map_if_absent(
				"n",
				"<leader>lth",
				buff.typehierarchy,
				vim.tbl_extend("force", opts, { desc = "Type hierarchy" })
			)
			map_if_absent(
				"n",
				"<leader>lo",
				":AerialToggle!<CR>",
				vim.tbl_extend("force", opts, { desc = "Toggle outline" })
			)
			map_if_absent(
				"n",
				"<leader>tc",
				":Coverage<CR>",
				vim.tbl_extend("force", opts, { desc = "Toggle coverage" })
			)

			map_if_absent("n", "<leader>sd", function()
				local dialects = {
					"postgres",
					"mysql",
					"sqlite",
					"tsql",
					"bigquery",
					"snowflake",
					"oracle",
					"clickhouse",
					"athena",
					"databricks",
					"duckdb",
					"mariadb",
					"redshift",
					"sparksql",
					"teradata",
					"trino",
					"vertica",
				}

				vim.ui.select(dialects, {
					prompt = "Select SQL Dialect:",
				}, function(choice)
					if choice then
						vim.b.sql_dialect = choice
						vim.notify("SQL dialect set to: " .. choice, vim.log.levels.INFO)
						vim.diagnostic.reset(nil, 0)
					end
				end)
			end, vim.tbl_extend("force", opts, { desc = "Set SQL dialect" }))

			map_if_absent("n", "<leader>sD", function()
				local dialect = vim.b.sql_dialect or "auto-detect (default: postgres)"
				vim.notify("Current SQL dialect: " .. dialect, vim.log.levels.INFO)
			end, vim.tbl_extend("force", opts, { desc = "Show SQL dialect" }))

			if vim.b[bufnr].lsp_format_on_save == nil then
				vim.b[bufnr].lsp_format_on_save = false
			end
			map_if_absent("n", "<leader>tf", function()
				if vim.b[bufnr].lsp_format_on_save then
					vim.b[bufnr].lsp_format_on_save = false
					vim.notify("LSP format on save disabled for buffer", vim.log.levels.INFO)
				else
					vim.b[bufnr].lsp_format_on_save = true
					vim.notify("LSP format on save enabled for buffer", vim.log.levels.INFO)
				end
			end, vim.tbl_extend("force", opts, { desc = "Toggle format on save" }))

			map_if_absent("n", "<leader>glb", function()
				vim.lsp.buf.format({
					async = false,
					filter = function(client)
						return client.name == "null-ls"
					end,
				})
				vim.lsp.buf.code_action({
					context = {
						only = { "source.organizeImports", "source.fixAll" },
						diagnostics = vim.diagnostic.get(0),
					},
					apply = true,
				})
				vim.notify("Manual formatting and linting triggered", vim.log.levels.INFO)
			end, vim.tbl_extend("force", opts, { desc = "Manual formatting and linting" }))

			local clients = vim.lsp.get_clients({ bufnr = bufnr })
			local ft = vim.bo[bufnr].filetype
			if ft == "cs" then
				local omnisharp_client = nil
				for _, client in ipairs(clients) do
					if client.name == "omnisharp" then
						omnisharp_client = client
						break
					end
				end

				if omnisharp_client then
					local function is_omnisharp_ready()
						return omnisharp_client.initialized or false
					end

					map_if_absent("n", "<leader>cu", function()
						if is_omnisharp_ready() then
							vim.lsp.buf.code_action({
								context = {
									only = { "source.addMissingImports" },
									diagnostics = vim.diagnostic.get(0),
								},
								apply = true,
							})
						else
							vim.notify("OmniSharp still initializing, please wait...", vim.log.levels.WARN)
						end
					end, vim.tbl_extend("force", opts, { desc = "Add missing usings" }))

					map_if_absent("n", "<leader>co", function()
						if is_omnisharp_ready() then
							vim.lsp.buf.code_action({
								context = {
									only = { "source.organizeImports" },
									diagnostics = vim.diagnostic.get(0),
								},
								apply = true,
							})
						else
							vim.notify("OmniSharp still initializing, please wait...", vim.log.levels.WARN)
						end
					end, vim.tbl_extend("force", opts, { desc = "Organize imports" }))

					map_if_absent("n", "<leader>cr", function()
						if is_omnisharp_ready() then
							vim.lsp.buf.code_action({
								context = {
									only = { "source.removeUnnecessaryImports" },
									diagnostics = vim.diagnostic.get(0),
								},
								apply = true,
							})
						else
							vim.notify("OmniSharp still initializing, please wait...", vim.log.levels.WARN)
						end
					end, vim.tbl_extend("force", opts, { desc = "Remove unnecessary usings" }))

					map_if_absent("n", "<leader>cd", function()
						if not is_omnisharp_ready() then
							vim.notify("OmniSharp still initializing, please wait...", vim.log.levels.WARN)
							return
						end

						local params = vim.lsp.util.make_range_params(bufnr, "utf-16")
						params.context = {
							diagnostics = vim.diagnostic.get(bufnr, { lnum = vim.fn.line(".") - 1 }),
						}

						vim.lsp.buf_request(bufnr, "textDocument/codeAction", params, function(err, result)
							if err then
								vim.notify("Error getting code actions: " .. err.message, vim.log.levels.ERROR)
								return
							end

							if not result or #result == 0 then
								vim.notify("No code actions available", vim.log.levels.INFO)
								return
							end

							print("Available code actions:")
							for i, action in ipairs(result) do
								print(
									string.format(
										"%d: %s (kind: %s)",
										i,
										action.title or "No title",
										action.kind or "No kind"
									)
								)
							end
						end)
					end, vim.tbl_extend("force", opts, { desc = "Debug code actions" }))

					if vim.fn.executable("netcoredbg") == 1 then
						map_if_absent("n", "<leader>rt", function()
							if is_omnisharp_ready() then
								vim.lsp.buf.code_action({
									context = {
										only = { "source.runTest" },
										diagnostics = vim.diagnostic.get(0),
									},
									apply = true,
								})
							else
								vim.notify("OmniSharp still initializing, please wait...", vim.log.levels.WARN)
							end
						end, vim.tbl_extend("force", opts, { desc = "Run test" }))

						map_if_absent("n", "<leader>dt", function()
							if is_omnisharp_ready() then
								vim.lsp.buf.code_action({
									context = {
										only = { "source.debugTest" },
										diagnostics = vim.diagnostic.get(0),
									},
									apply = true,
								})
							else
								vim.notify("OmniSharp still initializing, please wait...", vim.log.levels.WARN)
							end
						end, vim.tbl_extend("force", opts, { desc = "Debug test" }))
					end
				end
			end

			map_if_absent(
				"n",
				"<leader>lx",
				":LspToggleCurrent<CR>",
				vim.tbl_extend("force", opts, { desc = "Toggle dynamic LSP for this filetype" })
			)
		end,
	})

	vim.api.nvim_create_autocmd("FileType", {
		group = vim.api.nvim_create_augroup("LspKeymapsSqlNotice", { clear = true }),
		pattern = "sql",
		callback = function(args)
			if not vim.b[args.buf].sql_dialect then
				vim.defer_fn(function()
					vim.notify("SQL dialect: auto-detect (Press <leader>sd to change)", vim.log.levels.INFO)
				end, 1000)
			end
		end,
	})

	map_if_absent("n", "<leader>lT", ":LspToggleGlobal<CR>", { desc = "Toggle all dynamic LSP servers" })

	setup_done = true
end

M.setup_lsp_keymaps = M.setup

return M
