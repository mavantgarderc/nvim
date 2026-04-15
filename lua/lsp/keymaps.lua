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

-- ── helper: safe client capability check ──────────────────────────
local function client_supports(bufnr, capability_path)
	local clients = vim.lsp.get_clients({ bufnr = bufnr })
	for _, c in ipairs(clients) do
		local node = c.server_capabilities
		for segment in capability_path:gmatch("[^.]+") do
			if type(node) ~= "table" then
				node = nil
				break
			end
			node = node[segment]
		end
		if node then
			return true
		end
	end
	return false
end

-- ── helper: yank to register ──────────────────────────────────────
local function yank_to_register(text, reg)
	reg = reg or "+"
	vim.fn.setreg(reg, text)
	vim.notify("Yanked to register " .. reg, vim.log.levels.INFO)
end

-- ── helper: restart all clients on buffer ─────────────────────────
local function restart_buffer_clients(bufnr)
	local clients = vim.lsp.get_clients({ bufnr = bufnr })
	for _, c in ipairs(clients) do
		local name = c.name
		vim.lsp.stop_client(c.id, true)
		vim.defer_fn(function()
			vim.cmd("LspStart " .. name)
		end, 500)
	end
	vim.notify("Restarting LSP clients for buffer", vim.log.levels.INFO)
end

-- ── helper: collect all diagnostics text ──────────────────────────
local function diagnostics_to_string(bufnr, severity)
	local diags = vim.diagnostic.get(bufnr, severity and { severity = severity } or nil)
	if #diags == 0 then
		return "No diagnostics"
	end
	local lines = {}
	for _, d in ipairs(diags) do
		table.insert(lines, string.format("L%d: [%s] %s", d.lnum + 1, vim.diagnostic.severity[d.severity], d.message))
	end
	return table.concat(lines, "\n")
end

function M.setup()
	if setup_done then
		return
	end

	require("lsp.toggle").setup()
	require("lsp.info").setup()
	require("lsp.analytics").setup()

	-- ╔══════════════════════════════════════════════════════════════╗
	-- ║  GLOBAL KEYMAPS (no LspAttach required)                     ║
	-- ╚══════════════════════════════════════════════════════════════╝

	-- ── unchanged: existing global maps ───────────────────────────
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
	map_if_absent("n", "<leader>lT", ":LspToggleGlobal<CR>", { desc = "Toggle all dynamic LSP servers" })

	-- ── new: global LSP management ────────────────────────────────
	map_if_absent("n", "<leader>lR", ":LspRestart<CR>", { desc = "Restart all LSP servers" })
	map_if_absent("n", "<leader>lS", ":LspStop<CR>", { desc = "Stop all LSP servers" })
	map_if_absent("n", "<leader>lA", ":LspStart<CR>", { desc = "Start LSP servers" })

	map_if_absent("n", "<leader>lHH", function()
		vim.cmd("checkhealth lspconfig")
	end, { desc = "Run :checkhealth lspconfig" })

	map_if_absent("n", "<leader>lLo", function()
		local log = vim.lsp.get_log_path()
		vim.cmd("edit " .. log)
	end, { desc = "Open LSP log file" })

	map_if_absent("n", "<leader>lLc", function()
		local log = vim.lsp.get_log_path()
		if vim.fn.filereadable(log) == 1 then
			vim.fn.delete(log)
			vim.notify("LSP log cleared", vim.log.levels.INFO)
		else
			vim.notify("No LSP log found", vim.log.levels.WARN)
		end
	end, { desc = "Clear LSP log file" })

	map_if_absent("n", "<leader>lLs", function()
		local log = vim.lsp.get_log_path()
		if vim.fn.filereadable(log) == 1 then
			local size = vim.fn.getfsize(log)
			local unit = "B"
			local val = size
			if size > 1048576 then
				val = math.floor(size / 1048576 * 10) / 10
				unit = "MB"
			elseif size > 1024 then
				val = math.floor(size / 1024 * 10) / 10
				unit = "KB"
			end
			vim.notify(string.format("LSP log size: %s %s", val, unit), vim.log.levels.INFO)
		else
			vim.notify("No LSP log found", vim.log.levels.WARN)
		end
	end, { desc = "Show LSP log size" })

	-- ── new: global diagnostic severity filters ───────────────────
	map_if_absent("n", "<leader>dfe", function()
		vim.diagnostic.config({ virtual_text = { severity = vim.diagnostic.severity.ERROR } })
		vim.notify("Diagnostics: errors only", vim.log.levels.INFO)
	end, { desc = "Diagnostics filter: errors only" })

	map_if_absent("n", "<leader>dfw", function()
		vim.diagnostic.config({
			virtual_text = { severity = { min = vim.diagnostic.severity.WARN } },
		})
		vim.notify("Diagnostics: warnings+", vim.log.levels.INFO)
	end, { desc = "Diagnostics filter: warnings+" })

	map_if_absent("n", "<leader>dfi", function()
		vim.diagnostic.config({
			virtual_text = { severity = { min = vim.diagnostic.severity.INFO } },
		})
		vim.notify("Diagnostics: info+", vim.log.levels.INFO)
	end, { desc = "Diagnostics filter: info+" })

	map_if_absent("n", "<leader>dfh", function()
		vim.diagnostic.config({
			virtual_text = { severity = { min = vim.diagnostic.severity.HINT } },
		})
		vim.notify("Diagnostics: all (hint+)", vim.log.levels.INFO)
	end, { desc = "Diagnostics filter: all" })

	map_if_absent("n", "<leader>dfr", function()
		vim.diagnostic.config({ virtual_text = true })
		vim.notify("Diagnostics: filter reset", vim.log.levels.INFO)
	end, { desc = "Diagnostics filter: reset" })

	-- ── new: global diagnostic display toggles ────────────────────
	map_if_absent("n", "<leader>dtv", function()
		local cfg = vim.diagnostic.config()
		vim.diagnostic.config({ virtual_text = not cfg.virtual_text })
		vim.notify("Virtual text: " .. (cfg.virtual_text and "OFF" or "ON"), vim.log.levels.INFO)
	end, { desc = "Toggle diagnostic virtual text" })

	map_if_absent("n", "<leader>dtu", function()
		local cfg = vim.diagnostic.config()
		vim.diagnostic.config({ underline = not cfg.underline })
		vim.notify("Underline: " .. (cfg.underline and "OFF" or "ON"), vim.log.levels.INFO)
	end, { desc = "Toggle diagnostic underline" })

	map_if_absent("n", "<leader>dts", function()
		local cfg = vim.diagnostic.config()
		vim.diagnostic.config({ signs = not cfg.signs })
		vim.notify("Signs: " .. (cfg.signs and "OFF" or "ON"), vim.log.levels.INFO)
	end, { desc = "Toggle diagnostic signs" })

	map_if_absent("n", "<leader>dtf", function()
		local cfg = vim.diagnostic.config()
		local new_float = not cfg.float
		vim.diagnostic.config({ float = new_float and { border = "rounded" } or false })
		vim.notify("Float: " .. (cfg.float and "OFF" or "ON"), vim.log.levels.INFO)
	end, { desc = "Toggle diagnostic float" })

	map_if_absent("n", "<leader>dta", function()
		local cfg = vim.diagnostic.config()
		local any_on = cfg.virtual_text or cfg.underline or cfg.signs
		local new_state = not any_on
		vim.diagnostic.config({
			virtual_text = new_state,
			underline = new_state,
			signs = new_state,
		})
		vim.notify("All diagnostics: " .. (new_state and "ON" or "OFF"), vim.log.levels.INFO)
	end, { desc = "Toggle all diagnostic display" })

	-- ── new: diagnostic severity jump (global) ────────────────────
	map_if_absent("n", "<leader>[w", function()
		vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.WARN })
	end, { desc = "Previous warning" })
	map_if_absent("n", "<leader>]w", function()
		vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.WARN })
	end, { desc = "Next warning" })
	map_if_absent("n", "<leader>[h", function()
		vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.HINT })
	end, { desc = "Previous hint" })
	map_if_absent("n", "<leader>]h", function()
		vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.HINT })
	end, { desc = "Next hint" })
	map_if_absent("n", "<leader>[i", function()
		vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.INFO })
	end, { desc = "Previous info diagnostic" })
	map_if_absent("n", "<leader>]i", function()
		vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.INFO })
	end, { desc = "Next info diagnostic" })

	-- ── new: diagnostic yank / copy ───────────────────────────────
	map_if_absent("n", "<leader>dyy", function()
		local diag = vim.diagnostic.get(0, { lnum = vim.fn.line(".") - 1 })
		if #diag == 0 then
			vim.notify("No diagnostics on current line", vim.log.levels.INFO)
			return
		end
		local msgs = {}
		for _, d in ipairs(diag) do
			table.insert(msgs, d.message)
		end
		yank_to_register(table.concat(msgs, "\n"))
	end, { desc = "Yank line diagnostics" })

	map_if_absent("n", "<leader>dya", function()
		yank_to_register(diagnostics_to_string(0))
	end, { desc = "Yank all buffer diagnostics" })

	map_if_absent("n", "<leader>dye", function()
		yank_to_register(diagnostics_to_string(0, vim.diagnostic.severity.ERROR))
	end, { desc = "Yank all buffer errors" })

	-- ── new: diagnostic count display ─────────────────────────────
	map_if_absent("n", "<leader>dc", function()
		local diags = vim.diagnostic.get(0)
		local counts = { 0, 0, 0, 0 }
		for _, d in ipairs(diags) do
			counts[d.severity] = counts[d.severity] + 1
		end
		vim.notify(
			string.format("E:%d W:%d I:%d H:%d (total %d)", counts[1], counts[2], counts[3], counts[4], #diags),
			vim.log.levels.INFO
		)
	end, { desc = "Show diagnostic counts" })

	map_if_absent("n", "<leader>dC", function()
		local diags = vim.diagnostic.get()
		local counts = { 0, 0, 0, 0 }
		for _, d in ipairs(diags) do
			counts[d.severity] = counts[d.severity] + 1
		end
		vim.notify(
			string.format(
				"Workspace — E:%d W:%d I:%d H:%d (total %d)",
				counts[1],
				counts[2],
				counts[3],
				counts[4],
				#diags
			),
			vim.log.levels.INFO
		)
	end, { desc = "Show workspace diagnostic counts" })

	-- ── new: diagnostic quickfix / loclist ─────────────────────────
	map_if_absent("n", "<leader>dqe", function()
		vim.diagnostic.setqflist({ severity = vim.diagnostic.severity.ERROR })
	end, { desc = "Errors to quickfix" })

	map_if_absent("n", "<leader>dqw", function()
		vim.diagnostic.setqflist({ severity = vim.diagnostic.severity.WARN })
	end, { desc = "Warnings to quickfix" })

	map_if_absent("n", "<leader>dqa", function()
		vim.diagnostic.setqflist()
	end, { desc = "All diagnostics to quickfix" })

	map_if_absent("n", "<leader>dle", function()
		vim.diagnostic.setloclist({ severity = vim.diagnostic.severity.ERROR })
	end, { desc = "Errors to loclist" })

	map_if_absent("n", "<leader>dlw", function()
		vim.diagnostic.setloclist({ severity = vim.diagnostic.severity.WARN })
	end, { desc = "Warnings to loclist" })

	map_if_absent("n", "<leader>dla", function()
		vim.diagnostic.setloclist()
	end, { desc = "All diagnostics to loclist" })

	-- ── new: diagnostic reset ─────────────────────────────────────
	map_if_absent("n", "<leader>dR", function()
		vim.diagnostic.reset()
		vim.notify("All diagnostics reset", vim.log.levels.INFO)
	end, { desc = "Reset all diagnostics" })

	map_if_absent("n", "<leader>dr", function()
		vim.diagnostic.reset(nil, 0)
		vim.notify("Buffer diagnostics reset", vim.log.levels.INFO)
	end, { desc = "Reset buffer diagnostics" })

	-- ── new: LSP log level ────────────────────────────────────────
	map_if_absent("n", "<leader>lld", function()
		vim.lsp.set_log_level("DEBUG")
		vim.notify("LSP log level: DEBUG", vim.log.levels.INFO)
	end, { desc = "LSP log level: DEBUG" })

	map_if_absent("n", "<leader>lli", function()
		vim.lsp.set_log_level("INFO")
		vim.notify("LSP log level: INFO", vim.log.levels.INFO)
	end, { desc = "LSP log level: INFO" })

	map_if_absent("n", "<leader>llw", function()
		vim.lsp.set_log_level("WARN")
		vim.notify("LSP log level: WARN", vim.log.levels.INFO)
	end, { desc = "LSP log level: WARN" })

	map_if_absent("n", "<leader>lle", function()
		vim.lsp.set_log_level("ERROR")
		vim.notify("LSP log level: ERROR", vim.log.levels.INFO)
	end, { desc = "LSP log level: ERROR" })

	map_if_absent("n", "<leader>llo", function()
		vim.lsp.set_log_level("OFF")
		vim.notify("LSP log level: OFF", vim.log.levels.INFO)
	end, { desc = "LSP log level: OFF" })

	-- ── new: semantic tokens global toggle ────────────────────────
	map_if_absent("n", "<leader>cst", function()
		local enabled = vim.g.lsp_semantic_tokens ~= false
		vim.g.lsp_semantic_tokens = not enabled
		for _, c in ipairs(vim.lsp.get_clients()) do
			if c.server_capabilities.semanticTokensProvider then
				for _, b in ipairs(vim.lsp.get_buffers_by_client_id(c.id)) do
					if enabled then
						vim.lsp.semantic_tokens.stop(b, c.id)
					else
						vim.lsp.semantic_tokens.start(b, c.id)
					end
				end
			end
		end
		vim.notify("Semantic tokens: " .. (enabled and "OFF" or "ON"), vim.log.levels.INFO)
	end, { desc = "Toggle semantic tokens globally" })

	-- ╔══════════════════════════════════════════════════════════════╗
	-- ║  LspAttach KEYMAPS (buffer-local, require active client)    ║
	-- ╚══════════════════════════════════════════════════════════════╝

	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("LspKeymaps", { clear = true }),
		desc = "LSP actions",
		callback = function(event)
			local bufnr = event.buf
			local opts = { buffer = bufnr, silent = true }

			local function o(desc)
				return vim.tbl_extend("force", opts, { desc = desc })
			end

			-- ── unchanged: existing buffer maps ───────────────────
			map_if_absent("n", "<leader>K", ":LspHover<CR>", o("LSP hover"))
			map_if_absent("n", "<leader>gd", buff.definition, o("LSP definition"))
			map_if_absent("n", "<leader>gD", buff.declaration, o("LSP declaration"))
			map_if_absent("n", "<leader>gi", ":LspImplementation<CR>", o("LSP implementations"))
			map_if_absent("n", "<leader>go", ":LspTypeDefinition<CR>", o("LSP type definition"))
			map_if_absent("n", "<leader>gp", ":LspTypePeek<CR>", o("Peek type definition"))
			map_if_absent("n", "<leader>gr", ":LspRefFind<CR>", o("LSP references"))
			map_if_absent("n", "<leader>gs", buff.signature_help, o("LSP signature help"))
			map_if_absent("n", "<leader>grn", buff.rename, o("LSP rename"))
			map_if_absent("n", "<leader>ca", ":CodeAction<CR>", o("Code actions"))
			map_if_absent("v", "<leader>ca", buff.code_action, o("Range code actions"))
			map_if_absent("n", "<leader>gra", ":CodeActionTelescope<CR>", o("Code actions (picker)"))
			map_if_absent("x", "<leader>gra", buff.code_action, o("Range code actions"))
			map_if_absent("n", "<leader>e", vim.diagnostic.open_float, o("Line diagnostics"))
			map_if_absent("n", "<leader>q", vim.diagnostic.setloclist, o("Populate loclist"))
			map_if_absent("n", "<leader>[d", function()
				vim.diagnostic.jump({ count = -1 })
			end, o("Previous diagnostic"))
			map_if_absent("n", "<leader>]d", function()
				vim.diagnostic.jump({ count = 1 })
			end, o("Next diagnostic"))
			map_if_absent("n", "<leader>[e", function()
				vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR })
			end, o("Previous error"))
			map_if_absent("n", "<leader>]e", function()
				vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR })
			end, o("Next error"))
			map_if_absent("n", "<leader>wa", buff.add_workspace_folder, o("Add workspace folder"))
			map_if_absent("n", "<leader>wr", buff.remove_workspace_folder, o("Remove workspace folder"))
			map_if_absent("n", "<leader>wl", function()
				print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
			end, o("List workspace folders"))
			map_if_absent("n", "<leader>li", ":LspImplementation<CR>", o("LSP implementations"))
			map_if_absent("n", "<leader>lr", ":LspRefFind<CR>", o("LSP references"))
			map_if_absent("n", "<leader>ld", telescope_call("lsp_definitions", buff.definition), o("LSP definitions"))
			map_if_absent("n", "<leader>lt", ":LspTypePeek<CR>", o("Peek type definition"))
			map_if_absent("n", "<leader>ls", telescope_call("lsp_document_symbols"), o("Document symbols"))
			map_if_absent("n", "<leader>le", telescope_call("diagnostics"), o("Diagnostics picker"))
			map_if_absent("n", "<leader>lw", ":LspWorkspaceSymbol<CR>", o("Workspace symbols"))
			map_if_absent("n", "<leader>fs", ":LspWorkspaceSymbol<CR>", o("Workspace symbol search"))
			map_if_absent(
				"n",
				"<leader>fS",
				telescope_call("lsp_dynamic_workspace_symbols"),
				o("Dynamic workspace symbols")
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
			end, o("Open LSP log"))
			map_if_absent("n", "<leader>lth", buff.typehierarchy, o("Type hierarchy"))
			map_if_absent("n", "<leader>lo", ":AerialToggle!<CR>", o("Toggle outline"))
			map_if_absent("n", "<leader>tc", ":Coverage<CR>", o("Toggle coverage"))
			map_if_absent("n", "<leader>lx", ":LspToggleCurrent<CR>", o("Toggle dynamic LSP for this filetype"))

			-- ── unchanged: SQL dialect maps ───────────────────────
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
			end, o("Set SQL dialect"))

			map_if_absent("n", "<leader>sD", function()
				local dialect = vim.b.sql_dialect or "auto-detect (default: postgres)"
				vim.notify("Current SQL dialect: " .. dialect, vim.log.levels.INFO)
			end, o("Show SQL dialect"))

			-- ── unchanged: format on save toggle ──────────────────
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
			end, o("Toggle format on save"))

			-- ── unchanged: manual format + lint ───────────────────
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
			end, o("Manual formatting and linting"))

			-- ══════════════════════════════════════════════════════
			--  NEW BUFFER-LOCAL KEYMAPS START HERE
			-- ══════════════════════════════════════════════════════

			-- ── formatting ────────────────────────────────────────
			map_if_absent("n", "<leader>lf", function()
				buff.format({ async = true })
			end, o("Format buffer (async)"))

			map_if_absent("n", "<leader>lF", function()
				buff.format({ async = false })
			end, o("Format buffer (sync)"))

			map_if_absent("v", "<leader>lf", function()
				buff.format({ async = true })
			end, o("Format selection"))

			map_if_absent("n", "<leader>lfn", function()
				buff.format({
					async = true,
					filter = function(client)
						return client.name ~= "null-ls"
					end,
				})
			end, o("Format via LSP (skip null-ls)"))

			-- ── call hierarchy ────────────────────────────────────
			map_if_absent("n", "<leader>cI", function()
				buff.incoming_calls()
			end, o("Incoming calls"))

			map_if_absent("n", "<leader>cO", function()
				buff.outgoing_calls()
			end, o("Outgoing calls"))

			-- ── definition / declaration variants ─────────────────
			map_if_absent("n", "<leader>gds", function()
				buff.definition({ reuse_win = false })
				vim.cmd("split")
			end, o("Definition in split"))

			map_if_absent("n", "<leader>gdv", function()
				buff.definition({ reuse_win = false })
				vim.cmd("vsplit")
			end, o("Definition in vsplit"))

			map_if_absent("n", "<leader>gdt", function()
				vim.cmd("tab split")
				buff.definition()
			end, o("Definition in new tab"))

			map_if_absent("n", "<leader>gDs", function()
				vim.cmd("split")
				buff.declaration()
			end, o("Declaration in split"))

			map_if_absent("n", "<leader>gDv", function()
				vim.cmd("vsplit")
				buff.declaration()
			end, o("Declaration in vsplit"))

			-- ── implementation variants ───────────────────────────
			map_if_absent("n", "<leader>gis", function()
				vim.cmd("split")
				buff.implementation()
			end, o("Implementation in split"))

			map_if_absent("n", "<leader>giv", function()
				vim.cmd("vsplit")
				buff.implementation()
			end, o("Implementation in vsplit"))

			-- ── type definition variants ──────────────────────────
			map_if_absent("n", "<leader>gos", function()
				vim.cmd("split")
				buff.type_definition()
			end, o("Type definition in split"))

			map_if_absent("n", "<leader>gov", function()
				vim.cmd("vsplit")
				buff.type_definition()
			end, o("Type definition in vsplit"))

			-- ── references variants ───────────────────────────────
			map_if_absent("n", "<leader>gR", function()
				buff.references(nil, { loclist = true })
			end, o("References to loclist"))

			-- ── signature help in insert mode ─────────────────────
			map_if_absent("i", "<C-s>", buff.signature_help, o("Signature help (insert)"))
			map_if_absent("i", "<C-k>", buff.signature_help, o("Signature help (insert alt)"))

			-- ── hover variants ────────────────────────────────────
			map_if_absent("n", "K", buff.hover, o("Hover (native)"))

			map_if_absent("n", "<leader>Kf", function()
				vim.diagnostic.open_float({ scope = "buffer" })
			end, o("Buffer diagnostics float"))

			map_if_absent("n", "<leader>Kc", function()
				vim.diagnostic.open_float({ scope = "cursor" })
			end, o("Cursor diagnostics float"))

			map_if_absent("n", "<leader>Kl", function()
				vim.diagnostic.open_float({ scope = "line" })
			end, o("Line diagnostics float"))

			-- ── code action variants ──────────────────────────────
			map_if_absent("n", "<leader>caf", function()
				buff.code_action({
					context = {
						only = { "source.fixAll" },
						diagnostics = vim.diagnostic.get(bufnr),
					},
					apply = true,
				})
			end, o("Fix all auto-fixable"))

			map_if_absent("n", "<leader>cao", function()
				buff.code_action({
					context = {
						only = { "source.organizeImports" },
						diagnostics = vim.diagnostic.get(bufnr),
					},
					apply = true,
				})
			end, o("Organize imports"))

			map_if_absent("n", "<leader>car", function()
				buff.code_action({
					context = {
						only = { "refactor" },
						diagnostics = vim.diagnostic.get(bufnr),
					},
				})
			end, o("Refactor actions only"))

			map_if_absent("n", "<leader>cae", function()
				buff.code_action({
					context = {
						only = { "refactor.extract" },
						diagnostics = vim.diagnostic.get(bufnr),
					},
				})
			end, o("Extract actions only"))

			map_if_absent("v", "<leader>cae", function()
				buff.code_action({
					context = {
						only = { "refactor.extract" },
						diagnostics = vim.diagnostic.get(bufnr),
					},
				})
			end, o("Extract selection"))

			map_if_absent("n", "<leader>cai", function()
				buff.code_action({
					context = {
						only = { "refactor.inline" },
						diagnostics = vim.diagnostic.get(bufnr),
					},
				})
			end, o("Inline actions only"))

			map_if_absent("n", "<leader>caq", function()
				buff.code_action({
					context = {
						only = { "quickfix" },
						diagnostics = vim.diagnostic.get(bufnr),
					},
				})
			end, o("Quickfix actions only"))

			map_if_absent("n", "<leader>cas", function()
				buff.code_action({
					context = {
						only = { "source" },
						diagnostics = vim.diagnostic.get(bufnr),
					},
				})
			end, o("Source actions only"))

			-- ── codelens buffer controls ──────────────────────────
			map_if_absent("n", "<leader>cLr", function()
				vim.lsp.codelens.refresh({ bufnr = bufnr })
			end, o("Refresh codelens"))

			map_if_absent("n", "<leader>cLc", function()
				vim.lsp.codelens.clear(nil, bufnr)
			end, o("Clear codelens"))

			-- ── inlay hints buffer controls ───────────────────────
			map_if_absent("n", "<leader>cih", function()
				local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
				vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
				vim.notify("Inlay hints: " .. (enabled and "OFF" or "ON"), vim.log.levels.INFO)
			end, o("Toggle inlay hints (buffer)"))

			map_if_absent("n", "<leader>ciH", function()
				local enabled = vim.lsp.inlay_hint.is_enabled()
				vim.lsp.inlay_hint.enable(not enabled)
				vim.notify("Inlay hints global: " .. (enabled and "OFF" or "ON"), vim.log.levels.INFO)
			end, o("Toggle inlay hints (global)"))

			-- ── semantic tokens buffer controls ───────────────────
			map_if_absent("n", "<leader>csb", function()
				local clients = vim.lsp.get_clients({ bufnr = bufnr })
				for _, c in ipairs(clients) do
					if c.server_capabilities.semanticTokensProvider then
						pcall(vim.lsp.semantic_tokens.stop, bufnr, c.id)
					end
				end
				vim.notify("Semantic tokens stopped for buffer", vim.log.levels.INFO)
			end, o("Stop semantic tokens (buffer)"))

			map_if_absent("n", "<leader>csB", function()
				local clients = vim.lsp.get_clients({ bufnr = bufnr })
				for _, c in ipairs(clients) do
					if c.server_capabilities.semanticTokensProvider then
						pcall(vim.lsp.semantic_tokens.start, bufnr, c.id)
					end
				end
				vim.notify("Semantic tokens started for buffer", vim.log.levels.INFO)
			end, o("Start semantic tokens (buffer)"))

			-- ── client info / inspection ──────────────────────────
			map_if_absent("n", "<leader>lci", function()
				local clients = vim.lsp.get_clients({ bufnr = bufnr })
				if #clients == 0 then
					vim.notify("No LSP clients attached", vim.log.levels.WARN)
					return
				end
				local lines = {}
				for _, c in ipairs(clients) do
					table.insert(lines, string.format("• %s (id=%d) root=%s", c.name, c.id, c.root_dir or "nil"))
				end
				vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
			end, o("Show attached client info"))

			map_if_absent("n", "<leader>lcc", function()
				local clients = vim.lsp.get_clients({ bufnr = bufnr })
				if #clients == 0 then
					vim.notify("No LSP clients attached", vim.log.levels.WARN)
					return
				end
				local caps = {}
				for _, c in ipairs(clients) do
					table.insert(caps, string.format("── %s ──", c.name))
					for k, v in pairs(c.server_capabilities or {}) do
						if v and v ~= vim.NIL then
							table.insert(
								caps,
								string.format("  %s = %s", k, type(v) == "table" and "✓ (table)" or tostring(v))
							)
						end
					end
				end
				local tmpbuf = vim.api.nvim_create_buf(false, true)
				vim.api.nvim_buf_set_lines(tmpbuf, 0, -1, false, caps)
				vim.api.nvim_buf_set_option(tmpbuf, "bufhidden", "wipe")
				vim.api.nvim_buf_set_option(tmpbuf, "filetype", "markdown")
				vim.cmd("vsplit")
				vim.api.nvim_win_set_buf(0, tmpbuf)
			end, o("Show server capabilities"))

			map_if_absent("n", "<leader>lcr", function()
				local clients = vim.lsp.get_clients({ bufnr = bufnr })
				if #clients == 0 then
					vim.notify("No LSP clients attached", vim.log.levels.WARN)
					return
				end
				local names = {}
				for _, c in ipairs(clients) do
					table.insert(names, c.name)
				end
				vim.ui.select(names, { prompt = "Select client to restart:" }, function(choice)
					if not choice then
						return
					end
					for _, c in ipairs(clients) do
						if c.name == choice then
							vim.lsp.stop_client(c.id, true)
							vim.defer_fn(function()
								vim.cmd("LspStart " .. choice)
								vim.notify("Restarted: " .. choice, vim.log.levels.INFO)
							end, 500)
							break
						end
					end
				end)
			end, o("Restart selected client"))

			map_if_absent("n", "<leader>lcR", function()
				restart_buffer_clients(bufnr)
			end, o("Restart all buffer clients"))

			map_if_absent("n", "<leader>lcs", function()
				local clients = vim.lsp.get_clients({ bufnr = bufnr })
				if #clients == 0 then
					vim.notify("No LSP clients attached", vim.log.levels.WARN)
					return
				end
				local names = {}
				for _, c in ipairs(clients) do
					table.insert(names, c.name)
				end
				vim.ui.select(names, { prompt = "Select client to stop:" }, function(choice)
					if not choice then
						return
					end
					for _, c in ipairs(clients) do
						if c.name == choice then
							vim.lsp.stop_client(c.id, true)
							vim.notify("Stopped: " .. choice, vim.log.levels.INFO)
							break
						end
					end
				end)
			end, o("Stop selected client"))

			-- ── yank / copy helpers (buffer-local) ────────────────
			map_if_absent("n", "<leader>lyn", function()
				local clients = vim.lsp.get_clients({ bufnr = bufnr })
				if #clients == 0 then
					vim.notify("No LSP clients", vim.log.levels.WARN)
					return
				end
				local names = {}
				for _, c in ipairs(clients) do
					table.insert(names, c.name)
				end
				yank_to_register(table.concat(names, ", "))
			end, o("Yank client names"))

			map_if_absent("n", "<leader>lyr", function()
				local clients = vim.lsp.get_clients({ bufnr = bufnr })
				local roots = {}
				for _, c in ipairs(clients) do
					if c.root_dir then
						table.insert(roots, c.name .. ": " .. c.root_dir)
					end
				end
				if #roots == 0 then
					vim.notify("No root dirs found", vim.log.levels.WARN)
					return
				end
				yank_to_register(table.concat(roots, "\n"))
			end, o("Yank root dirs"))

			-- ── workspace folder management ───────────────────────
			map_if_absent("n", "<leader>wf", function()
				local folders = vim.lsp.buf.list_workspace_folders()
				if #folders == 0 then
					vim.notify("No workspace folders", vim.log.levels.INFO)
					return
				end
				vim.ui.select(folders, { prompt = "Workspace folders:" }, function() end)
			end, o("Pick workspace folder"))

			map_if_absent("n", "<leader>wc", function()
				local folders = vim.lsp.buf.list_workspace_folders()
				yank_to_register(table.concat(folders, "\n"))
			end, o("Yank workspace folders"))

			-- ── document highlight ────────────────────────────────
			map_if_absent("n", "<leader>uh", function()
				buff.document_highlight()
			end, o("Highlight symbol under cursor"))

			map_if_absent("n", "<leader>uH", function()
				vim.lsp.buf.clear_references()
			end, o("Clear symbol highlights"))

			-- ── auto document highlight on hold ───────────────────
			map_if_absent("n", "<leader>uha", function()
				if vim.b[bufnr].lsp_document_highlight_auto then
					vim.b[bufnr].lsp_document_highlight_auto = false
					pcall(vim.api.nvim_del_augroup_by_name, "LspDocHighlight_" .. bufnr)
					vim.lsp.buf.clear_references()
					vim.notify("Auto document highlight: OFF", vim.log.levels.INFO)
				else
					vim.b[bufnr].lsp_document_highlight_auto = true
					local group = vim.api.nvim_create_augroup("LspDocHighlight_" .. bufnr, { clear = true })
					vim.api.nvim_create_autocmd("CursorHold", {
						group = group,
						buffer = bufnr,
						callback = function()
							pcall(buff.document_highlight)
						end,
					})
					vim.api.nvim_create_autocmd("CursorMoved", {
						group = group,
						buffer = bufnr,
						callback = function()
							pcall(vim.lsp.buf.clear_references)
						end,
					})
					vim.notify("Auto document highlight: ON", vim.log.levels.INFO)
				end
			end, o("Toggle auto document highlight"))

			-- ── formatting: select client ─────────────────────────
			map_if_absent("n", "<leader>lfc", function()
				local clients = vim.lsp.get_clients({ bufnr = bufnr })
				local formatters = {}
				for _, c in ipairs(clients) do
					if c.server_capabilities.documentFormattingProvider then
						table.insert(formatters, c.name)
					end
				end
				if #formatters == 0 then
					vim.notify("No formatting-capable clients", vim.log.levels.WARN)
					return
				end
				vim.ui.select(formatters, { prompt = "Format with:" }, function(choice)
					if choice then
						buff.format({
							async = true,
							filter = function(client)
								return client.name == choice
							end,
						})
					end
				end)
			end, o("Format: pick client"))

			-- ── range formatting ──────────────────────────────────
			map_if_absent("v", "<leader>lf", function()
				buff.format({ async = true })
			end, o("Format range"))

			-- ── document link ─────────────────────────────────────
			map_if_absent("n", "<leader>ll", function()
				local params = vim.lsp.util.make_position_params()
				vim.lsp.buf_request(bufnr, "textDocument/documentLink", {
					textDocument = params.textDocument,
				}, function(err, result)
					if err or not result or #result == 0 then
						vim.notify("No document links found", vim.log.levels.INFO)
						return
					end
					local links = {}
					for _, link in ipairs(result) do
						if link.target then
							table.insert(links, link.target)
						end
					end
					vim.ui.select(links, { prompt = "Document links:" }, function(choice)
						if choice then
							vim.ui.open(choice)
						end
					end)
				end)
			end, o("Browse document links"))

			-- ── fold via LSP ──────────────────────────────────────
			map_if_absent("n", "<leader>lzf", function()
				if client_supports(bufnr, "foldingRangeProvider") then
					vim.wo.foldmethod = "expr"
					vim.wo.foldexpr = "v:lua.vim.lsp.foldexpr()"
					vim.notify("LSP folding enabled", vim.log.levels.INFO)
				else
					vim.notify("Server does not support folding", vim.log.levels.WARN)
				end
			end, o("Enable LSP folding"))

			map_if_absent("n", "<leader>lzr", function()
				vim.wo.foldmethod = "manual"
				vim.wo.foldexpr = ""
				vim.cmd("normal! zE")
				vim.notify("LSP folding disabled", vim.log.levels.INFO)
			end, o("Disable LSP folding"))

			-- ── selection range (smart expand/shrink) ─────────────
			map_if_absent("n", "<leader>lsr", function()
				if client_supports(bufnr, "selectionRangeProvider") then
					buff.selection_range()
				else
					vim.notify("Server does not support selection range", vim.log.levels.WARN)
				end
			end, o("LSP selection range"))

			-- ── rename: word under cursor (prefilled) ─────────────
			map_if_absent("n", "<leader>rw", function()
				local word = vim.fn.expand("<cword>")
				vim.ui.input({ prompt = "Rename: ", default = word }, function(new_name)
					if new_name and new_name ~= "" and new_name ~= word then
						buff.rename(new_name)
					end
				end)
			end, o("Rename with input (prefilled)"))

			-- ── rename: empty input ───────────────────────────────
			map_if_absent("n", "<leader>re", function()
				vim.ui.input({ prompt = "Rename to: " }, function(new_name)
					if new_name and new_name ~= "" then
						buff.rename(new_name)
					end
				end)
			end, o("Rename with empty input"))

			-- ── server request: textDocument/documentSymbol raw ───
			map_if_absent("n", "<leader>lSr", function()
				local params = { textDocument = vim.lsp.util.make_text_document_params() }
				vim.lsp.buf_request(bufnr, "textDocument/documentSymbol", params, function(err, result)
					if err then
						vim.notify("Error: " .. err.message, vim.log.levels.ERROR)
						return
					end
					if not result or #result == 0 then
						vim.notify("No symbols found", vim.log.levels.INFO)
						return
					end
					local lines = {}
					for _, sym in ipairs(result) do
						table.insert(
							lines,
							string.format(
								"[%s] %s  L%d",
								vim.lsp.protocol.SymbolKind[sym.kind] or "?",
								sym.name,
								(sym.range or sym.location.range).start.line + 1
							)
						)
					end
					local tmpbuf = vim.api.nvim_create_buf(false, true)
					vim.api.nvim_buf_set_lines(tmpbuf, 0, -1, false, lines)
					vim.api.nvim_buf_set_option(tmpbuf, "bufhidden", "wipe")
					vim.cmd("botright split")
					vim.api.nvim_win_set_buf(0, tmpbuf)
					vim.api.nvim_win_set_height(0, math.min(#lines + 1, 20))
				end)
			end, o("Raw document symbols"))

			-- ── buffer diagnostics to scratch buffer ──────────────
			map_if_absent("n", "<leader>dB", function()
				local text = diagnostics_to_string(bufnr)
				local tmpbuf = vim.api.nvim_create_buf(false, true)
				vim.api.nvim_buf_set_lines(tmpbuf, 0, -1, false, vim.split(text, "\n"))
				vim.api.nvim_buf_set_option(tmpbuf, "bufhidden", "wipe")
				vim.cmd("botright split")
				vim.api.nvim_win_set_buf(0, tmpbuf)
			end, o("Diagnostics to scratch buffer"))

			-- ── diagnostic: go to first / last ────────────────────
			map_if_absent("n", "<leader>dF", function()
				local diags = vim.diagnostic.get(bufnr)
				if #diags == 0 then
					vim.notify("No diagnostics", vim.log.levels.INFO)
					return
				end
				table.sort(diags, function(a, b)
					return a.lnum < b.lnum
				end)
				vim.api.nvim_win_set_cursor(0, { diags[1].lnum + 1, diags[1].col })
			end, o("Jump to first diagnostic"))

			map_if_absent("n", "<leader>dL", function()
				local diags = vim.diagnostic.get(bufnr)
				if #diags == 0 then
					vim.notify("No diagnostics", vim.log.levels.INFO)
					return
				end
				table.sort(diags, function(a, b)
					return a.lnum > b.lnum
				end)
				vim.api.nvim_win_set_cursor(0, { diags[1].lnum + 1, diags[1].col })
			end, o("Jump to last diagnostic"))

			-- ── toggle virtual lines (Neovim 0.11+) ──────────────
			map_if_absent("n", "<leader>dvl", function()
				local cfg = vim.diagnostic.config()
				if cfg.virtual_lines then
					vim.diagnostic.config({ virtual_lines = false })
					vim.notify("Virtual lines: OFF", vim.log.levels.INFO)
				else
					vim.diagnostic.config({ virtual_lines = { only_current_line = true } })
					vim.notify("Virtual lines: ON (current line)", vim.log.levels.INFO)
				end
			end, o("Toggle diagnostic virtual lines"))

			map_if_absent("n", "<leader>dvL", function()
				local cfg = vim.diagnostic.config()
				if
					cfg.virtual_lines
					and not (type(cfg.virtual_lines) == "table" and cfg.virtual_lines.only_current_line)
				then
					vim.diagnostic.config({ virtual_lines = false })
					vim.notify("Virtual lines (all): OFF", vim.log.levels.INFO)
				else
					vim.diagnostic.config({ virtual_lines = true })
					vim.notify("Virtual lines (all): ON", vim.log.levels.INFO)
				end
			end, o("Toggle diagnostic virtual lines (all)"))

			-- ── request timeout format ────────────────────────────
			map_if_absent("n", "<leader>lft", function()
				vim.ui.input({ prompt = "Format timeout (ms): ", default = "5000" }, function(val)
					local ms = tonumber(val)
					if ms then
						buff.format({ async = false, timeout_ms = ms })
					end
				end)
			end, o("Format with custom timeout"))

			-- ── show server status / init options ─────────────────
			map_if_absent("n", "<leader>lcI", function()
				local clients = vim.lsp.get_clients({ bufnr = bufnr })
				if #clients == 0 then
					vim.notify("No LSP clients", vim.log.levels.WARN)
					return
				end
				local lines = {}
				for _, c in ipairs(clients) do
					table.insert(lines, string.format("── %s (id=%d) ──", c.name, c.id))
					table.insert(lines, "  cmd: " .. table.concat(c.config.cmd or {}, " "))
					table.insert(lines, "  root: " .. (c.root_dir or "nil"))
					table.insert(lines, "  filetypes: " .. table.concat(c.config.filetypes or {}, ", "))
					table.insert(lines, "  offset_encoding: " .. (c.offset_encoding or "utf-16"))
					table.insert(lines, "")
				end
				local tmpbuf = vim.api.nvim_create_buf(false, true)
				vim.api.nvim_buf_set_lines(tmpbuf, 0, -1, false, lines)
				vim.api.nvim_buf_set_option(tmpbuf, "bufhidden", "wipe")
				vim.cmd("botright split")
				vim.api.nvim_win_set_buf(0, tmpbuf)
				vim.api.nvim_win_set_height(0, math.min(#lines + 1, 25))
			end, o("Detailed client init info"))

			-- ── peek definition in float ──────────────────────────
			map_if_absent("n", "<leader>gpd", function()
				local params = vim.lsp.util.make_position_params()
				vim.lsp.buf_request(bufnr, "textDocument/definition", params, function(err, result)
					if err or not result or (vim.islist(result) and #result == 0) then
						vim.notify("No definition found", vim.log.levels.INFO)
						return
					end
					local target = vim.islist(result) and result[1] or result
					if target.targetUri then
						target = { uri = target.targetUri, range = target.targetRange }
					end
					vim.lsp.util.preview_location(target, {})
				end)
			end, o("Peek definition in float"))

			-- ── peek declaration in float ─────────────────────────
			map_if_absent("n", "<leader>gpD", function()
				local params = vim.lsp.util.make_position_params()
				vim.lsp.buf_request(bufnr, "textDocument/declaration", params, function(err, result)
					if err or not result or (vim.islist(result) and #result == 0) then
						vim.notify("No declaration found", vim.log.levels.INFO)
						return
					end
					local target = vim.islist(result) and result[1] or result
					if target.targetUri then
						target = { uri = target.targetUri, range = target.targetRange }
					end
					vim.lsp.util.preview_location(target, {})
				end)
			end, o("Peek declaration in float"))

			-- ── token under cursor info ───────────────────────────
			map_if_absent("n", "<leader>lti", function()
				local token = vim.inspect(vim.lsp.semantic_tokens.get_at_pos(bufnr))
				if token == "nil" or token == "{}" then
					vim.notify("No semantic token at cursor", vim.log.levels.INFO)
				else
					vim.notify(token, vim.log.levels.INFO)
				end
			end, o("Inspect semantic token at cursor"))

			-- ── toggle diagnostic sort by severity ────────────────
			map_if_absent("n", "<leader>dss", function()
				local cfg = vim.diagnostic.config()
				local current = cfg.severity_sort
				vim.diagnostic.config({ severity_sort = not current })
				vim.notify("Severity sort: " .. (current and "OFF" or "ON"), vim.log.levels.INFO)
			end, o("Toggle diagnostic severity sort"))

			-- ── toggle diagnostic update in insert ────────────────
			map_if_absent("n", "<leader>dui", function()
				local cfg = vim.diagnostic.config()
				local current = cfg.update_in_insert
				vim.diagnostic.config({ update_in_insert = not current })
				vim.notify("Update in insert: " .. (current and "OFF" or "ON"), vim.log.levels.INFO)
			end, o("Toggle diagnostics update in insert"))

			-- ── capability check shortcuts ────────────────────────
			map_if_absent("n", "<leader>l?f", function()
				local ok = client_supports(bufnr, "documentFormattingProvider")
				vim.notify("Formatting: " .. (ok and "✓" or "✗"), vim.log.levels.INFO)
			end, o("Check: formatting support"))

			map_if_absent("n", "<leader>l?r", function()
				local ok = client_supports(bufnr, "renameProvider")
				vim.notify("Rename: " .. (ok and "✓" or "✗"), vim.log.levels.INFO)
			end, o("Check: rename support"))

			map_if_absent("n", "<leader>l?h", function()
				local ok = client_supports(bufnr, "hoverProvider")
				vim.notify("Hover: " .. (ok and "✓" or "✗"), vim.log.levels.INFO)
			end, o("Check: hover support"))

			map_if_absent("n", "<leader>l?c", function()
				local ok = client_supports(bufnr, "codeActionProvider")
				vim.notify("Code actions: " .. (ok and "✓" or "✗"), vim.log.levels.INFO)
			end, o("Check: code action support"))

			map_if_absent("n", "<leader>l?i", function()
				local ok = client_supports(bufnr, "implementationProvider")
				vim.notify("Implementation: " .. (ok and "✓" or "✗"), vim.log.levels.INFO)
			end, o("Check: implementation support"))

			map_if_absent("n", "<leader>l?d", function()
				local ok = client_supports(bufnr, "definitionProvider")
				vim.notify("Definition: " .. (ok and "✓" or "✗"), vim.log.levels.INFO)
			end, o("Check: definition support"))

			map_if_absent("n", "<leader>l?t", function()
				local ok = client_supports(bufnr, "typeDefinitionProvider")
				vim.notify("Type definition: " .. (ok and "✓" or "✗"), vim.log.levels.INFO)
			end, o("Check: type definition support"))

			map_if_absent("n", "<leader>l?s", function()
				local ok = client_supports(bufnr, "signatureHelpProvider")
				vim.notify("Signature help: " .. (ok and "✓" or "✗"), vim.log.levels.INFO)
			end, o("Check: signature help support"))

			map_if_absent("n", "<leader>l?S", function()
				local ok = client_supports(bufnr, "semanticTokensProvider")
				vim.notify("Semantic tokens: " .. (ok and "✓" or "✗"), vim.log.levels.INFO)
			end, o("Check: semantic tokens support"))

			map_if_absent("n", "<leader>l?a", function()
				local ok = client_supports(bufnr, "callHierarchyProvider")
				vim.notify("Call hierarchy: " .. (ok and "✓" or "✗"), vim.log.levels.INFO)
			end, o("Check: call hierarchy support"))
		end,
	})
end

return M
