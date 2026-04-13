-- lua/lsp/references.lua
-- Cross-Package Reference Finder with monorepo grouping

local M = {}

local monorepo = require("lsp.monorepo")

---@class RefEntry
---@field filename string
---@field lnum number
---@field col number
---@field text string
---@field package_name string|nil

local cache = {}
local cache_ttl = 30 -- seconds

local function get_cache_key(bufnr, pos)
	local uri = vim.uri_from_bufnr(bufnr)
	return string.format("%s:%d:%d", uri, pos[1], pos[2])
end

local function is_cache_valid(key)
	local entry = cache[key]
	if not entry then
		return false
	end
	return (vim.loop.now() - entry.time) < (cache_ttl * 1000)
end

local function detect_package(filepath)
	local root = monorepo.detect_root(filepath)
	if not root then
		return nil
	end

	local rel = filepath:sub(#root + 2)
	local pkg = rel:match("^packages/([^/]+)/")
		or rel:match("^apps/([^/]+)/")
		or rel:match("^libs/([^/]+)/")
		or rel:match("^modules/([^/]+)/")
		or rel:match("^services/([^/]+)/")
	return pkg
end

local function group_by_package(refs)
	local groups = {}
	local no_pkg = {}

	for _, ref in ipairs(refs) do
		local pkg = detect_package(ref.filename)
		ref.package_name = pkg
		if pkg then
			groups[pkg] = groups[pkg] or {}
			table.insert(groups[pkg], ref)
		else
			table.insert(no_pkg, ref)
		end
	end

	return groups, no_pkg
end

local function format_ref(ref)
	local rel = vim.fn.fnamemodify(ref.filename, ":~:.")
	local prefix = ref.package_name and ("[" .. ref.package_name .. "] ") or ""
	return string.format("%s%s:%d:%d: %s", prefix, rel, ref.lnum, ref.col, ref.text)
end

local function collect_references(result)
	local refs = {}
	for _, loc in ipairs(result or {}) do
		local uri = loc.uri or loc.targetUri
		local range = loc.range or loc.targetSelectionRange
		if uri and range then
			local filename = vim.uri_to_fname(uri)
			local lnum = range.start.line + 1
			local col = range.start.character + 1
			local text = ""
			pcall(function()
				local lines = vim.fn.readfile(filename, "", lnum)
				if lines and lines[lnum] then
					text = vim.trim(lines[lnum])
				end
			end)
			table.insert(refs, {
				filename = filename,
				lnum = lnum,
				col = col,
				text = text,
			})
		end
	end
	return refs
end

local function show_qf(refs, title)
	local items = {}
	for _, ref in ipairs(refs) do
		table.insert(items, {
			filename = ref.filename,
			lnum = ref.lnum,
			col = ref.col,
			text = format_ref(ref),
		})
	end
	vim.fn.setqflist({}, " ", { title = title, items = items })
	vim.cmd("copen")
end

local function show_telescope(refs, title)
	local ok_telescope, _ = pcall(require, "telescope")
	if not ok_telescope then
		show_qf(refs, title)
		return
	end

	local pickers = require("telescope.pickers")
	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")
	local previewers = require("telescope.previewers")

	local entries = {}
	for _, ref in ipairs(refs) do
		table.insert(entries, {
			value = ref,
			display = format_ref(ref),
			ordinal = format_ref(ref),
			filename = ref.filename,
			lnum = ref.lnum,
			col = ref.col,
		})
	end

	pickers
		.new({}, {
			prompt_title = title,
			finder = finders.new_table({
				results = entries,
				entry_maker = function(entry)
					return entry
				end,
			}),
			sorter = conf.generic_sorter({}),
			previewer = previewers.vim_buffer_vimgrep.new({}),
			attach_mappings = function(prompt_bufnr, map)
				actions.select_default:replace(function()
					local selection = action_state.get_selected_entry()
					actions.close(prompt_bufnr)
					if selection then
						vim.cmd("edit " .. vim.fn.fnameescape(selection.filename))
						local buf_lines = vim.api.nvim_buf_line_count(0)
						local target_lnum = math.min(selection.lnum, buf_lines)
						local line_text = vim.api.nvim_buf_get_lines(0, target_lnum - 1, target_lnum, false)[1] or ""
						local target_col = math.min(selection.col, #line_text + 1)
						vim.api.nvim_win_set_cursor(0, { target_lnum, target_col - 1 })
					end
				end)
				return true
			end,
		})
		:find()
end

function M.find_references(opts)
	opts = opts or {}
	local bufnr = vim.api.nvim_get_current_buf()
	local pos = vim.api.nvim_win_get_cursor(0)
	local cache_key = get_cache_key(bufnr, pos)

	if is_cache_valid(cache_key) then
		local cached = cache[cache_key].refs
		show_telescope(cached, "References (cached)")
		return
	end

	local params = vim.lsp.util.make_position_params()
	params.context = { includeDeclaration = opts.include_declaration ~= false }

	vim.lsp.buf_request_all(bufnr, "textDocument/references", params, function(results)
		local all_refs = {}
		for _, res in pairs(results) do
			if res.result then
				local refs = collect_references(res.result)
				vim.list_extend(all_refs, refs)
			end
		end

		if #all_refs == 0 then
			vim.notify("No references found", vim.log.levels.INFO)
			return
		end

		-- deduplicate
		local seen = {}
		local unique = {}
		for _, ref in ipairs(all_refs) do
			local key = ref.filename .. ":" .. ref.lnum .. ":" .. ref.col
			if not seen[key] then
				seen[key] = true
				table.insert(unique, ref)
			end
		end

		cache[cache_key] = { refs = unique, time = vim.loop.now() }

		vim.schedule(function()
			show_telescope(unique, string.format("References (%d found)", #unique))
		end)
	end)
end

function M.summary()
	local bufnr = vim.api.nvim_get_current_buf()
	local pos = vim.api.nvim_win_get_cursor(0)
	local cache_key = get_cache_key(bufnr, pos)

	if not is_cache_valid(cache_key) then
		vim.notify("No cached references. Run :LspRefFind first.", vim.log.levels.WARN)
		return
	end

	local refs = cache[cache_key].refs
	local groups, no_pkg = group_by_package(refs)

	local lines = { "=== Reference Summary ===" }
	table.insert(lines, string.format("Total: %d references", #refs))
	table.insert(lines, "")

	for pkg, pkg_refs in pairs(groups) do
		table.insert(lines, string.format("[%s] %d refs", pkg, #pkg_refs))
	end
	if #no_pkg > 0 then
		table.insert(lines, string.format("[root] %d refs", #no_pkg))
	end

	vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
end

function M.setup()
	vim.api.nvim_create_user_command("LspRefFind", function()
		M.find_references()
	end, { desc = "Find all references (cross-package)" })

	vim.api.nvim_create_user_command("LspRefSummary", function()
		M.summary()
	end, { desc = "Show reference summary by package" })

	vim.keymap.set("n", "grr", function()
		M.find_references()
	end, { desc = "LSP: Find references (cross-package)" })

	vim.keymap.set("n", "grs", function()
		M.summary()
	end, { desc = "LSP: Reference summary" })
end

return M
