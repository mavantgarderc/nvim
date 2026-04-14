local M = {}

local ns = vim.api.nvim_create_namespace("lsp_diagnostics_ex")
local monorepo = require("lsp.monorepo")
local dynamic = require("lsp.dynamic")
local setup_done = false

---@class DiagEntry
---@field file string
---@field lnum number
---@field col number
---@field severity number
---@field message string
---@field source string
---@field package string|nil

---@type table<string, DiagEntry[]>  -- keyed by monorepo root or "default"
local diag_cache = {}

-- severity labels for display
local sev_label = { "E", "W", "I", "H" }
local sev_name = { "Error", "Warn", "Info", "Hint" }
local sev_hl = {
	"DiagnosticError",
	"DiagnosticWarn",
	"DiagnosticInfo",
	"DiagnosticHint",
}

--- Resolve which package a file belongs to within a monorepo
---@param filepath string
---@param root string
---@return string
local function resolve_package(filepath, root)
	return monorepo.find_package_name(filepath, root) or "."
end

--- Collect all diagnostics from vim.diagnostic, grouped by workspace root
---@return table<string, table<string, DiagEntry[]>>  root -> package -> entries
local function collect()
	diag_cache = {}

	local all_bufs = vim.api.nvim_list_bufs()
	for _, buf in ipairs(all_bufs) do
		if vim.api.nvim_buf_is_loaded(buf) then
			local fname = vim.api.nvim_buf_get_name(buf)
			if fname and fname ~= "" then
				local diagnostics = vim.diagnostic.get(buf)
				if #diagnostics > 0 then
					local root = monorepo.find_monorepo_root(fname) or vim.fn.getcwd()
					local pkg = resolve_package(fname, root)

					if not diag_cache[root] then
						diag_cache[root] = {}
					end
					if not diag_cache[root][pkg] then
						diag_cache[root][pkg] = {}
					end

					for _, d in ipairs(diagnostics) do
						table.insert(diag_cache[root][pkg], {
							file = fname,
							lnum = d.lnum + 1,
							col = d.col + 1,
							severity = d.severity,
							message = d.message,
							source = d.source or "unknown",
							package = pkg,
						})
					end
				end
			end
		end
	end

	return diag_cache
end

--- Count diagnostics by severity for a given entry list
---@param entries DiagEntry[]
---@return number[] counts indexed by severity (1-4)
local function count_by_severity(entries)
	local counts = { 0, 0, 0, 0 }
	for _, e in ipairs(entries) do
		local s = e.severity or 4
		counts[s] = counts[s] + 1
	end
	return counts
end

--- Format severity counts into a compact string: E:3 W:1 I:0 H:0
---@param counts number[]
---@return string
local function format_counts(counts)
	local parts = {}
	for i = 1, 4 do
		if counts[i] > 0 then
			table.insert(parts, sev_label[i] .. ":" .. counts[i])
		end
	end
	return #parts > 0 and table.concat(parts, " ") or "clean"
end

--- :DiagSummary — print workspace-wide diagnostics grouped by package
function M.summary()
	local data = collect()

	if vim.tbl_isempty(data) then
		vim.notify("No diagnostics across workspace", vim.log.levels.INFO)
		return
	end

	local lines = {}
	for root, packages in pairs(data) do
		table.insert(lines, "Root: " .. root)

		-- sort packages alphabetically
		local pkg_names = vim.tbl_keys(packages)
		table.sort(pkg_names)

		for _, pkg in ipairs(pkg_names) do
			local entries = packages[pkg]
			local counts = count_by_severity(entries)
			table.insert(lines, string.format("  %-30s %s", pkg, format_counts(counts)))
		end
		table.insert(lines, "")
	end

	-- display in a scratch buffer
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.bo[buf].modifiable = false
	vim.bo[buf].buftype = "nofile"
	vim.bo[buf].filetype = "diagnostics_summary"
	vim.cmd("botright split")
	vim.api.nvim_win_set_buf(0, buf)
	vim.api.nvim_win_set_height(0, math.min(#lines + 1, 20))
end

--- :DiagFocus [package] — filter diagnostics to a specific package, send to quickfix
---@param pkg_filter string|nil
function M.focus(pkg_filter)
	local data = collect()
	local qf_items = {}

	for root, packages in pairs(data) do
		for pkg, entries in pairs(packages) do
			if not pkg_filter or pkg == pkg_filter then
				for _, e in ipairs(entries) do
					table.insert(qf_items, {
						filename = e.file,
						lnum = e.lnum,
						col = e.col,
						text = string.format("[%s] [%s] %s", sev_label[e.severity] or "?", e.source, e.message),
						type = sev_label[e.severity] or "E",
					})
				end
			end
		end
	end

	if #qf_items == 0 then
		local msg = pkg_filter and string.format("No diagnostics in package '%s'", pkg_filter) or "No diagnostics found"
		vim.notify(msg, vim.log.levels.INFO)
		return
	end

	-- sort by severity then file
	table.sort(qf_items, function(a, b)
		if a.type ~= b.type then
			return a.type < b.type
		end
		if a.filename ~= b.filename then
			return a.filename < b.filename
		end
		return a.lnum < b.lnum
	end)

	vim.fn.setqflist({}, " ", {
		title = pkg_filter and ("Diagnostics: " .. pkg_filter) or "Diagnostics: all",
		items = qf_items,
	})
	vim.cmd("copen")
end

--- Telescope picker for workspace diagnostics
---@param opts table|nil
function M.telescope_pick(opts)
	local has_telescope, pickers = pcall(require, "telescope.pickers")
	if not has_telescope then
		vim.notify("Telescope not available, falling back to quickfix", vim.log.levels.WARN)
		M.focus(opts and opts.package)
		return
	end

	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")
	local entry_display = require("telescope.pickers.entry_display")

	local data = collect()
	local flat = {}

	for root, packages in pairs(data) do
		for pkg, entries in pairs(packages) do
			if not (opts and opts.package) or pkg == opts.package then
				for _, e in ipairs(entries) do
					table.insert(flat, e)
				end
			end
		end
	end

	-- sort: errors first
	table.sort(flat, function(a, b)
		if a.severity ~= b.severity then
			return a.severity < b.severity
		end
		if a.file ~= b.file then
			return a.file < b.file
		end
		return a.lnum < b.lnum
	end)

	local displayer = entry_display.create({
		separator = " ",
		items = {
			{ width = 1 },
			{ width = 6 },
			{ remaining = true },
		},
	})

	pickers
		.new(opts or {}, {
			prompt_title = "Workspace Diagnostics",
			finder = finders.new_table({
				results = flat,
				entry_maker = function(e)
					local rel = vim.fn.fnamemodify(e.file, ":~:.")
					return {
						value = e,
						display = function(entry)
							local v = entry.value
							return displayer({
								{ sev_label[v.severity] or "?", sev_hl[v.severity] or "Normal" },
								{ v.package or ".", "Comment" },
								{ string.format("%s:%d %s", rel, v.lnum, v.message) },
							})
						end,
						ordinal = string.format("%s %s %s", sev_name[e.severity], rel, e.message),
						filename = e.file,
						lnum = e.lnum,
						col = e.col,
					}
				end,
			}),
			sorter = conf.generic_sorter(opts or {}),
			previewer = conf.grep_previewer(opts or {}),
			attach_mappings = function(prompt_bufnr)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local sel = action_state.get_selected_entry()
					if sel then
						vim.cmd("edit " .. vim.fn.fnameescape(sel.filename))
						-- clamp cursor to actual buffer dimensions
						local line_count = vim.api.nvim_buf_line_count(0)
						local target_lnum = math.min(sel.lnum, line_count)
						local line = vim.api.nvim_buf_get_lines(0, target_lnum - 1, target_lnum, false)[1] or ""
						local target_col = math.min(math.max(sel.col - 1, 0), #line)
						vim.api.nvim_win_set_cursor(0, { target_lnum, target_col })
					end
				end)
				return true
			end,
		})
		:find()
end

--- Setup commands, keymaps, and autorefresh
function M.setup()
	if setup_done then
		return
	end

	-- Commands
	vim.api.nvim_create_user_command("DiagSummary", function()
		M.summary()
	end, { desc = "Workspace diagnostics summary by package" })

	vim.api.nvim_create_user_command("DiagFocus", function(cmd_opts)
		local pkg = cmd_opts.args ~= "" and cmd_opts.args or nil
		M.focus(pkg)
	end, {
		nargs = "?",
		desc = "Filter diagnostics to a package (quickfix)",
		complete = function()
			-- offer package names from current cache
			local data = collect()
			local pkgs = {}
			local seen = {}
			for _, packages in pairs(data) do
				for pkg in pairs(packages) do
					if not seen[pkg] then
						seen[pkg] = true
						table.insert(pkgs, pkg)
					end
				end
			end
			table.sort(pkgs)
			return pkgs
		end,
	})

	vim.api.nvim_create_user_command("DiagPicker", function()
		M.telescope_pick()
	end, { desc = "Telescope picker for workspace diagnostics" })

	-- Auto-refresh cache on DiagnosticChanged
	vim.api.nvim_create_autocmd("DiagnosticChanged", {
		group = vim.api.nvim_create_augroup("lsp_diagnostics_ex", { clear = true }),
		callback = function()
			-- lightweight: just invalidate cache so next query is fresh
			diag_cache = {}
		end,
	})

	setup_done = true
end

return M
