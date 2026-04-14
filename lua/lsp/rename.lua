-- lua/lsp/rename.lua
-- Cross-package smart rename with preview, monorepo awareness, and undo

local M = {}

local monorepo = require("lsp.monorepo")
local commands_registered = false

local _history = {} -- rename history stack for undo
local _cache_roots = {} -- path -> { root, pkg, ts }
local CACHE_TTL = 30 -- seconds

-- ── Helpers ──────────────────────────────────────────────────────

---@param path string
---@return string? root, string? pkg
local function resolve_package(path)
	local cached = _cache_roots[path]
	if cached and (vim.uv.now() / 1000 - cached.ts) < CACHE_TTL then
		return cached.root, cached.pkg
	end

	local root = monorepo.find_monorepo_root(path)
	if root and path:find(root, 1, true) == 1 then
		local pkg = monorepo.find_package_name(path, root) or "(root)"
		_cache_roots[path] = { root = root, pkg = pkg, ts = vim.uv.now() / 1000 }
		return root, pkg
	end

	_cache_roots[path] = { root = nil, pkg = nil, ts = vim.uv.now() / 1000 }
	return nil, nil
end

--- Get word under cursor
---@return string
local function cursor_word()
	return vim.fn.expand("<cword>")
end

--- Collect affected files from a WorkspaceEdit
---@param edit table LSP WorkspaceEdit
---@return table<string, number> file -> change count
local function affected_files(edit)
	local files = {}

	-- documentChanges (versioned)
	if edit.documentChanges then
		for _, change in ipairs(edit.documentChanges) do
			if change.textDocument then
				local uri = change.textDocument.uri
				local path = vim.uri_to_fname(uri)
				files[path] = (files[path] or 0) + #(change.edits or {})
			end
		end
	end

	-- changes (unversioned)
	if edit.changes then
		for uri, edits in pairs(edit.changes) do
			local path = vim.uri_to_fname(uri)
			files[path] = (files[path] or 0) + #edits
		end
	end

	return files
end

--- Group files by monorepo package
---@param files table<string, number>
---@return table<string, table<string, number>>
local function group_by_package(files)
	local groups = {}
	for path, count in pairs(files) do
		local _, pkg = resolve_package(path)
		pkg = pkg or "(unknown)"
		if not groups[pkg] then
			groups[pkg] = {}
		end
		groups[pkg][path] = count
	end
	return groups
end

-- ── Preview ──────────────────────────────────────────────────────

--- Show a preview of what the rename will affect
---@param old_name string
---@param new_name string
---@param edit table WorkspaceEdit
---@return boolean confirmed
local function preview_rename(old_name, new_name, edit)
	local files = affected_files(edit)
	local groups = group_by_package(files)

	local total_files = vim.tbl_count(files)
	local total_edits = 0
	for _, c in pairs(files) do
		total_edits = total_edits + c
	end

	local lines = {
		string.format("Rename: %s → %s", old_name, new_name),
		string.format("Affects %d file(s), %d edit(s)", total_files, total_edits),
		"",
	}

	local pkgs = vim.tbl_keys(groups)
	table.sort(pkgs)
	for _, pkg in ipairs(pkgs) do
		table.insert(lines, string.format("  📦 %s", pkg))
		local paths = vim.tbl_keys(groups[pkg])
		table.sort(paths)
		for _, path in ipairs(paths) do
			local rel = vim.fn.fnamemodify(path, ":~:.")
			table.insert(lines, string.format("    %s (%d edits)", rel, groups[pkg][path]))
		end
	end

	table.insert(lines, "")
	table.insert(lines, "Apply? [y/N]")

	local choice = vim.fn.confirm(table.concat(lines, "\n"), "&Yes\n&No", 2)
	return choice == 1
end

-- ── Core rename ──────────────────────────────────────────────────

--- Perform rename with preview and history tracking
---@param opts? { new_name?: string, preview?: boolean }
function M.rename(opts)
	opts = opts or {}
	local bufnr = vim.api.nvim_get_current_buf()
	local clients = vim.lsp.get_clients({ bufnr = bufnr, method = "textDocument/rename" })

	if #clients == 0 then
		vim.notify("[rename] No LSP server supports rename", vim.log.levels.WARN)
		return
	end

	local old_name = cursor_word()
	if old_name == "" then
		vim.notify("[rename] No word under cursor", vim.log.levels.WARN)
		return
	end

	local do_rename = function(new_name)
		if not new_name or new_name == "" or new_name == old_name then
			return
		end

		local params = vim.lsp.util.make_position_params()
		params.newName = new_name

		-- if preview requested, do prepareRename + dry-run first
		if opts.preview ~= false then
			vim.lsp.buf_request_all(bufnr, "textDocument/rename", params, function(results)
				-- merge workspace edits from all clients
				local merged_edit = { changes = {}, documentChanges = {} }
				for _, res in pairs(results) do
					if res.result then
						if res.result.changes then
							for uri, edits in pairs(res.result.changes) do
								merged_edit.changes[uri] = merged_edit.changes[uri] or {}
								vim.list_extend(merged_edit.changes[uri], edits)
							end
						end
						if res.result.documentChanges then
							vim.list_extend(merged_edit.documentChanges, res.result.documentChanges)
						end
					end
				end

				-- check if anything would change
				local files = affected_files(merged_edit)
				if vim.tbl_isempty(files) then
					vim.notify("[rename] No references found", vim.log.levels.INFO)
					return
				end

				vim.schedule(function()
					local confirmed = preview_rename(old_name, new_name, merged_edit)
					if not confirmed then
						vim.notify("[rename] Cancelled", vim.log.levels.INFO)
						return
					end

					-- record for undo
					table.insert(_history, {
						old = old_name,
						new = new_name,
						bufnr = bufnr,
						pos = vim.api.nvim_win_get_cursor(0),
						time = os.time(),
					})

					-- apply
					vim.lsp.util.apply_workspace_edit(merged_edit, "utf-8")
					vim.notify(
						string.format("[rename] %s → %s (%d files)", old_name, new_name, vim.tbl_count(files)),
						vim.log.levels.INFO
					)
				end)
			end)
		else
			-- no preview, just rename directly
			table.insert(_history, {
				old = old_name,
				new = new_name,
				bufnr = bufnr,
				pos = vim.api.nvim_win_get_cursor(0),
				time = os.time(),
			})
			vim.lsp.buf.rename(new_name)
		end
	end

	if opts.new_name then
		do_rename(opts.new_name)
	else
		vim.ui.input({ prompt = "Rename: ", default = old_name }, function(input)
			do_rename(input)
		end)
	end
end

--- Quick rename without preview
---@param new_name? string
function M.rename_quick(new_name)
	M.rename({ new_name = new_name, preview = false })
end

-- ── History / Undo ───────────────────────────────────────────────

--- Show rename history
function M.history()
	if #_history == 0 then
		vim.notify("[rename] No rename history", vim.log.levels.INFO)
		return
	end

	local lines = { "Rename History (newest first):" }
	for i = #_history, 1, -1 do
		local h = _history[i]
		local ago = os.time() - h.time
		local time_str
		if ago < 60 then
			time_str = ago .. "s ago"
		elseif ago < 3600 then
			time_str = math.floor(ago / 60) .. "m ago"
		else
			time_str = math.floor(ago / 3600) .. "h ago"
		end
		table.insert(lines, string.format("  %d. %s → %s  (%s)", i, h.old, h.new, time_str))
	end

	vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
end

--- Undo last rename (re-triggers rename with swapped names)
function M.undo()
	if #_history == 0 then
		vim.notify("[rename] Nothing to undo", vim.log.levels.WARN)
		return
	end

	local last = table.remove(_history)

	-- jump back to original buffer/position if possible
	if vim.api.nvim_buf_is_valid(last.bufnr) then
		local wins = vim.fn.win_findbuf(last.bufnr)
		if #wins > 0 then
			vim.api.nvim_set_current_win(wins[1])
		else
			vim.cmd("buffer " .. last.bufnr)
		end
		pcall(vim.api.nvim_win_set_cursor, 0, last.pos)
	end

	-- search for the new name under cursor to position correctly
	vim.fn.search("\\<" .. vim.fn.escape(last.new, "\\") .. "\\>", "cw")

	vim.notify(string.format("[rename] Undoing: %s → %s", last.new, last.old), vim.log.levels.INFO)

	-- perform reverse rename without preview
	M.rename({ new_name = last.old, preview = false })
end

-- ── Summary ──────────────────────────────────────────────────────

--- Show a summary of what renaming the current symbol would affect
function M.summary()
	local bufnr = vim.api.nvim_get_current_buf()
	local clients = vim.lsp.get_clients({ bufnr = bufnr, method = "textDocument/rename" })

	if #clients == 0 then
		vim.notify("[rename] No LSP server supports rename", vim.log.levels.WARN)
		return
	end

	local word = cursor_word()
	if word == "" then
		return
	end

	local params = vim.lsp.util.make_position_params()
	params.newName = word .. "_dry_run_probe"

	vim.lsp.buf_request_all(bufnr, "textDocument/rename", params, function(results)
		local merged = { changes = {}, documentChanges = {} }
		for _, res in pairs(results) do
			if res.result then
				if res.result.changes then
					for uri, edits in pairs(res.result.changes) do
						merged.changes[uri] = merged.changes[uri] or {}
						vim.list_extend(merged.changes[uri], edits)
					end
				end
				if res.result.documentChanges then
					vim.list_extend(merged.documentChanges, res.result.documentChanges)
				end
			end
		end

		local files = affected_files(merged)
		local groups = group_by_package(files)

		local total_files = vim.tbl_count(files)
		local total_edits = 0
		for _, c in pairs(files) do
			total_edits = total_edits + c
		end

		vim.schedule(function()
			local lines = {
				string.format("Symbol: %s", word),
				string.format("References: %d file(s), %d location(s)", total_files, total_edits),
				"",
			}

			local pkgs = vim.tbl_keys(groups)
			table.sort(pkgs)
			for _, pkg in ipairs(pkgs) do
				local pkg_edits = 0
				for _, c in pairs(groups[pkg]) do
					pkg_edits = pkg_edits + c
				end
				table.insert(
					lines,
					string.format("  📦 %-30s %d edits in %d files", pkg, pkg_edits, vim.tbl_count(groups[pkg]))
				)
			end

			vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
		end)
	end)
end

-- ── Setup ────────────────────────────────────────────────────────

function M.setup()
	if commands_registered then
		return
	end

	vim.api.nvim_create_user_command("Rename", function(cmd)
		local arg = cmd.args ~= "" and cmd.args or nil
		M.rename({ new_name = arg })
	end, { nargs = "?", desc = "Smart rename with preview" })

	vim.api.nvim_create_user_command("RenameQuick", function(cmd)
		local arg = cmd.args ~= "" and cmd.args or nil
		M.rename_quick(arg)
	end, { nargs = "?", desc = "Rename without preview" })

	vim.api.nvim_create_user_command("RenameUndo", function()
		M.undo()
	end, { desc = "Undo last rename" })

	vim.api.nvim_create_user_command("RenameHistory", function()
		M.history()
	end, { desc = "Show rename history" })

	vim.api.nvim_create_user_command("RenameSummary", function()
		M.summary()
	end, { desc = "Show rename impact summary" })

	commands_registered = true
end

return M
