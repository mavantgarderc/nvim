local map = vim.keymap.set
local buff = vim.lsp.buf

local M = {}

function M.setup_lsp_keymaps()
	vim.api.nvim_create_autocmd("LspAttach", {
		desc = "LSP actions",
		callback = function(event)
			local opts = { buffer = event.buf, silent = true }

			map("n", "<leader>K", buff.hover, opts)
			map("n", "<leader>gd", buff.definition, opts)
			map("n", "<leader>gD", buff.declaration, opts)
			map("n", "<leader>gi", buff.implementation, opts)
			map("n", "<leader>go", buff.type_definition, opts)
			map("n", "<leader>gr", buff.references, opts)
			map("n", "<leader>gs", buff.signature_help, opts)

			map("n", "<leader>grn", buff.rename, opts)
			map("n", "<leader>ca", buff.code_action, opts)
			map("v", "<leader>ca", buff.code_action, opts)
			map({ "n", "x" }, "<leader>gra", buff.code_action, opts)

			map("n", "<leader>e", vim.diagnostic.open_float, opts)
			map("n", "<leader>q", vim.diagnostic.setloclist, opts)
			map("n", "<leader>[d", function()
				vim.diagnostic.jump({ count = -1 })
			end, opts)
			map("n", "<leader>]d", function()
				vim.diagnostic.jump({ count = 1 })
			end, opts)

			map("n", "<leader>[e", function()
				vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR })
			end, opts)
			map("n", "<leader>]e", function()
				vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR })
			end, opts)

			map("n", "<leader>wa", buff.add_workspace_folder, opts)
			map("n", "<leader>wr", buff.remove_workspace_folder, opts)
			map("n", "<leader>wl", function()
				print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
			end, opts)

			local has_telescope, telescope = pcall(require, "telescope.builtin")
			if has_telescope then
				map("n", "<leader>li", telescope.lsp_implementations, { desc = "LSP implementations" })
				map("n", "<leader>lr", telescope.lsp_references, { desc = "LSP references" })
				map("n", "<leader>ld", telescope.lsp_definitions, { desc = "LSP definitions" })
				map("n", "<leader>lt", telescope.lsp_type_definitions, { desc = "LSP type definitions" })
				map("n", "<leader>ls", telescope.lsp_document_symbols, { desc = "Document symbols" })
				map("n", "<leader>le", telescope.diagnostics, { desc = "Diagnostics" })
				map("n", "<leader>lw", telescope.lsp_workspace_symbols, { desc = "Workspace symbols" })
			end

			map("n", "<leader>fs", function()
				require("telescope.builtin").lsp_workspace_symbols({
					query = vim.fn.input("Workspace Symbol: "),
				})
			end, { desc = "Semantic Search (Workspace Symbols)" })

			map("n", "<leader>fS", function()
				require("telescope.builtin").lsp_dynamic_workspace_symbols()
			end, { desc = "Dynamic Workspace Symbols" })

			map("n", "<leader>lh", function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
			end, { desc = "Toggle Inlay Hints" })

			-- view LSP Logs
			map("n", "<leader>lL", function()
				require("telescope.builtin").find_files({
					cwd = vim.fn.stdpath("cache"),
					prompt_title = "LSP Logs",
					find_command = { "rg", "--files", "--glob", "lsp.log" },
				})
			end, { desc = "Open LSP Log" })

			map("n", "<leader>lI", function()
				require("lsp.info").show_server_info()
			end, { desc = "LSP Server Info" })

			map("n", "<leader>la", function()
				require("lsp.analytics").show_report()
			end, { desc = "LSP Analytics" })

			map("n", "<leader>lth", vim.lsp.buf.typehierarchy, { desc = "Type Hierarchy" })

			map("n", "<leader>lo", "<cmd>AerialToggle!<cr>", { desc = "Toggle Outline" })

			map("n", "<leader>tc", "<cmd>Coverage<cr>", { desc = "Toggle Coverage" })

			-- SQL Dialect Keymaps
			map("n", "<leader>sd", function()
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
						-- Trigger diagnostics refresh
						vim.diagnostic.reset(nil, 0)
					end
				end)
			end, { desc = "Set SQL Dialect" })

			-- Show current SQL dialect
			map("n", "<leader>sD", function()
				local dialect = vim.b.sql_dialect or "auto-detect (default: postgres)"
				vim.notify("Current SQL dialect: " .. dialect, vim.log.levels.INFO)
			end, { desc = "Show SQL Dialect" })

			-- toggle auto-lint
			vim.b.lsp_format_on_save = false
			map("n", "<leader>tf", function()
				if vim.b.lsp_format_on_save then
					vim.b.lsp_format_on_save = false
					vim.notify("LSP format on save disabled for buffer", vim.log.levels.INFO)
				else
					vim.b.lsp_format_on_save = true
					vim.notify("LSP format on save enabled for buffer", vim.log.levels.INFO)
				end
			end, opts)

			-- lint
			map("n", "<leader>glb", function()
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
				vim.notify("Manual formatting & linting triggered", vim.log.levels.INFO)
			end, { desc = "Manual formatting & linting (F3)" })

			-- Get client information for language-specific keymaps
			local clients = vim.lsp.get_clients({ bufnr = event.buf })
			local client_names = {}
			for _, client in ipairs(clients) do
				table.insert(client_names, client.name)
			end

			-- C# / OmniSharp specific keymaps
			local ft = vim.bo[event.buf].filetype
			if ft == "cs" then
				local omnisharp_client = nil
				for _, client in ipairs(clients) do
					if client.name == "omnisharp" then
						omnisharp_client = client
						break
					end
				end

				if omnisharp_client then
					-- Helper function to check if OmniSharp is ready
					local function is_omnisharp_ready()
						return omnisharp_client.initialized or false
					end

					-- Add missing usings
					map("n", "<leader>cu", function()
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

					-- Organize imports
					map("n", "<leader>co", function()
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

					-- Remove unnecessary usings
					map("n", "<leader>cr", function()
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

					-- Debug code actions
					map("n", "<leader>cd", function()
						if not is_omnisharp_ready() then
							vim.notify("OmniSharp still initializing, please wait...", vim.log.levels.WARN)
							return
						end

						local params = vim.lsp.util.make_range_params(event.buf, "utf-16")
						params.context = {
							diagnostics = vim.diagnostic.get(event.buf, { lnum = vim.fn.line(".") - 1 }),
						}

						vim.lsp.buf_request(
							event.buf,
							"textDocument/codeAction",
							params,
							function(err, result, _ctx, _config)
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
							end
						)
					end, vim.tbl_extend("force", opts, { desc = "Debug code actions" }))

					-- Test running keymaps (if netcoredbg is available)
					if vim.fn.executable("netcoredbg") == 1 then
						map("n", "<leader>rt", function()
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

						map("n", "<leader>dt", function()
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

			-- LSP toggle keymap
			map("n", "<leader>lt", function()
				require("lsp.toggle").toggle_lsp()
			end, vim.tbl_extend("force", opts, { desc = "Toggle LSP" }))
		end,
	})

	-- Auto-notify about SQL dialect on SQL files
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "sql",
		callback = function(args)
			if not vim.b[args.buf].sql_dialect then
				vim.defer_fn(function()
					vim.notify("SQL dialect: auto-detect (Press <leader>sd to change)", vim.log.levels.INFO)
				end, 1000)
			end
		end,
	})
end

-- Add global LSP toggle keymap
vim.keymap.set("n", "<leader>lT", function()
	require("lsp.toggle").toggle_lsp_globally()
end, { desc = "Toggle LSP globally" })

return M
