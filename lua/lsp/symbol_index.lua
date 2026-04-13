local M = {}

local monorepo = require("monorepo")

-- ── Symbol Cache ─────────────────────────────────────────────────
-- { [filepath] = { mtime = number, symbols = { {name, kind, lnum, col, end_lnum, end_col, file} } } }
local cache = {}
local ns = vim.api.nvim_create_namespace("symbol_index")

local kind_map = {
	["function"] = "Function",
	["method"] = "Method",
	["class"] = "Class",
	["module"] = "Module",
	["variable"] = "Variable",
	["type"] = "Type",
	["interface"] = "Interface",
	["struct"] = "Struct",
	["enum"] = "Enum",
	["constant"] = "Constant",
	["field"] = "Field",
	["property"] = "Property",
	["constructor"] = "Constructor",
	["namespace"] = "Namespace",
}

-- ── Treesitter symbol extraction ─────────────────────────────────
-- Queries for definition nodes per language
local ts_queries = {
	lua = [[
		(function_declaration name: (_) @name) @definition.function
		(assignment_statement (variable_list name: (_) @name) (expression_list value: (function_definition))) @definition.function
	]],
	python = [[
		(function_definition name: (identifier) @name) @definition.function
		(class_definition name: (identifier) @name) @definition.class
	]],
	typescript = [[
		(function_declaration name: (identifier) @name) @definition.function
		(class_declaration name: (type_identifier) @name) @definition.class
		(interface_declaration name: (type_identifier) @name) @definition.interface
		(type_alias_declaration name: (type_identifier) @name) @definition.type
		(enum_declaration name: (identifier) @name) @definition.enum
	]],
	go = [[
		(function_declaration name: (identifier) @name) @definition.function
		(method_declaration name: (field_identifier) @name) @definition.method
		(type_declaration (type_spec name: (type_identifier) @name)) @definition.type
	]],
	rust = [[
		(function_item name: (identifier) @name) @definition.function
		(struct_item name: (type_identifier) @name) @definition.struct
		(enum_item name: (type_identifier) @name) @definition.enum
		(impl_item type: (type_identifier) @name) @definition.class
		(trait_item name: (type_identifier) @name) @definition.interface
	]],
}

-- javascript/tsx reuse typescript query
ts_queries.javascript = ts_queries.typescript
ts_queries.typescriptreact = ts_queries.typescript
ts_queries.javascriptreact = ts_queries.typescript

local function kind_from_capture(capture_name)
	-- capture_name is like "definition.function" → extract "function"
	local suffix = capture_name:match("^definition%.(.+)$")
	return kind_map[suffix] or "Variable"
end

local function extract_ts_symbols(filepath, lang)
	local query_str = ts_queries[lang]
	if not query_str then
		return nil
	end

	local ok, query = pcall(vim.treesitter.query.parse, lang, query_str)
	if not ok or not query then
		return nil
	end

	-- read file without loading into a buffer
	local lines = vim.fn.readfile(filepath)
	if not lines or #lines == 0 then
		return nil
	end
	local source = table.concat(lines, "\n")

	local parser_ok, parser = pcall(vim.treesitter.get_string_parser, source, lang)
	if not parser_ok or not parser then
		return nil
	end

	local trees = parser:parse()
	if not trees or not trees[1] then
		return nil
	end

	local root = trees[1]:root()
	local symbols = {}
	local seen_ranges = {}

	for id, node in query:iter_captures(root, source, 0, -1) do
		local capture_name = query.captures[id]
		if capture_name == "name" then
			local name = vim.treesitter.get_node_text(node, source)
			local sr, sc, er, ec = node:range()
			local range_key = sr .. ":" .. sc

			-- find the parent definition capture for kind
			local parent = node:parent()
			local kind = "Variable"
			if parent then
				for pid, pnode in query:iter_captures(root, source, 0, -1) do
					local pcap = query.captures[pid]
					if pcap:match("^definition%.") and pnode == parent then
						kind = kind_from_capture(pcap)
						break
					end
				end
			end

			if not seen_ranges[range_key] then
				seen_ranges[range_key] = true
				table.insert(symbols, {
					name = name,
					kind = kind,
					lnum = sr + 1,
					col = sc + 1,
					end_lnum = er + 1,
					end_col = ec + 1,
					file = filepath,
					source = "treesitter",
				})
			end
		end
	end

	return symbols
end

-- ── File scanning ────────────────────────────────────────────────
local ext_to_lang = {
	lua = "lua",
	py = "python",
	ts = "typescript",
	tsx = "typescriptreact",
	js = "javascript",
	jsx = "javascriptreact",
	go = "go",
	rs = "rust",
}

local function scan_file(filepath)
	local stat = vim.uv.fs_stat(filepath)
	if not stat then
		return nil
	end

	local entry = cache[filepath]
	if entry and entry.mtime == stat.mtime.sec then
		return entry.symbols
	end

	local ext = filepath:match("%.(%w+)$")
	local lang = ext_to_lang[ext]
	if not lang then
		return nil
	end

	local symbols = extract_ts_symbols(filepath, lang) or {}

	cache[filepath] = {
		mtime = stat.mtime.sec,
		symbols = symbols,
	}

	return symbols
end

-- ── Workspace file discovery ─────────────────────────────────────
local function find_workspace_root()
	local fname = vim.api.nvim_buf_get_name(0)
	if fname == "" then
		return vim.fn.getcwd()
	end

	-- try monorepo roots first
	local root = monorepo.get_ts_root(fname) or monorepo.get_python_root(fname) or monorepo.get_go_root(fname)

	if not root then
		root = vim.fs.root(0, { ".git", "pyproject.toml", "Cargo.toml", "go.work", "package.json" })
	end

	return root or vim.fn.getcwd()
end

local ignore_dirs = {
	[".git"] = true,
	["node_modules"] = true,
	["__pycache__"] = true,
	[".mypy_cache"] = true,
	[".ruff_cache"] = true,
	["target"] = true,
	["dist"] = true,
	["build"] = true,
	[".next"] = true,
	["vendor"] = true,
	[".venv"] = true,
	["venv"] = true,
}

local valid_extensions = {}
for ext, _ in pairs(ext_to_lang) do
	valid_extensions[ext] = true
end

local function collect_files(root, max_files)
	max_files = max_files or 5000
	local files = {}
	local count = 0

	local function walk(dir)
		if count >= max_files then
			return
		end
		local handle = vim.uv.fs_scandir(dir)
		if not handle then
			return
		end
		while count < max_files do
			local name, typ = vim.uv.fs_scandir_next(handle)
			if not name then
				break
			end
			local full = dir .. "/" .. name
			if typ == "directory" then
				if not ignore_dirs[name] then
					walk(full)
				end
			elseif typ == "file" then
				local ext = name:match("%.(%w+)$")
				if ext and valid_extensions[ext] then
					count = count + 1
					files[count] = full
				end
			end
		end
	end

	walk(root)
	return files
end

-- ── LSP symbol merge ─────────────────────────────────────────────
local function fetch_lsp_symbols(query, callback)
	local clients = vim.lsp.get_clients({ bufnr = 0 })
	local results = {}
	local pending = 0

	for _, client in ipairs(clients) do
		if client.server_capabilities.workspaceSymbolProvider then
			pending = pending + 1
			client:request("workspace/symbol", { query = query }, function(err, result)
				if not err and result then
					for _, sym in ipairs(result) do
						local loc = sym.location
						if loc and loc.uri then
							table.insert(results, {
								name = sym.name,
								kind = vim.lsp.protocol.SymbolKind[sym.kind] or "Unknown",
								file = vim.uri_to_fname(loc.uri),
								lnum = (loc.range and loc.range.start.line or 0) + 1,
								col = (loc.range and loc.range.start.character or 0) + 1,
								source = "lsp:" .. client.name,
							})
						end
					end
				end
				pending = pending - 1
				if pending == 0 then
					callback(results)
				end
			end, 0)
		end
	end

	if pending == 0 then
		callback(results)
	end
end

local function merge_symbols(ts_symbols, lsp_symbols)
	-- LSP symbols override treesitter for same file+line
	local index = {}
	local merged = {}

	for _, sym in ipairs(ts_symbols) do
		local key = sym.file .. ":" .. sym.lnum
		index[key] = sym
		table.insert(merged, sym)
	end

	for _, sym in ipairs(lsp_symbols) do
		local key = sym.file .. ":" .. sym.lnum
		if index[key] then
			-- update in place — LSP has richer kind info
			index[key].kind = sym.kind
			index[key].source = sym.source
		else
			table.insert(merged, sym)
		end
	end

	return merged
end

-- ── Monorepo package resolution ──────────────────────────────────
local function resolve_package(filepath, root)
	-- find which package/project a file belongs to
	local rel = filepath:sub(#root + 2) -- strip root + separator
	local parts = vim.split(rel, "/", { plain = true })

	-- common monorepo layouts: packages/X, apps/X, projects/X, services/X
	local pkg_dirs = { packages = true, apps = true, projects = true, services = true, libs = true }
	if #parts >= 2 and pkg_dirs[parts[1]] then
		return parts[1] .. "/" .. parts[2]
	end

	return nil
end

-- ── Telescope picker ─────────────────────────────────────────────
local function open_picker(symbols, root)
	local has_telescope, pickers = pcall(require, "telescope.pickers")
	if not has_telescope then
		-- fallback: quickfix
		local items = {}
		for _, sym in ipairs(symbols) do
			table.insert(items, {
				filename = sym.file,
				lnum = sym.lnum,
				col = sym.col or 1,
				text = string.format("[%s] %s", sym.kind, sym.name),
			})
		end
		vim.fn.setqflist(items, "r")
		vim.cmd("copen")
		return
	end

	local finders = require("telescope.finders")
	local conf = require("telescope.config").values
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")
	local entry_display = require("telescope.pickers.entry_display")

	local displayer = entry_display.create({
		separator = " ",
		items = {
			{ width = 12 }, -- kind
			{ width = 40 }, -- name
			{ width = 20 }, -- package
			{ remaining = true }, -- file:line
		},
	})

	local function make_display(entry)
		local rel = entry.file
		if root and entry.file:sub(1, #root) == root then
			rel = entry.file:sub(#root + 2)
		end
		return displayer({
			{ entry.kind, "TelescopeResultsIdentifier" },
			{ entry.name, "TelescopeResultsFunction" },
			{ entry.package or "", "TelescopeResultsComment" },
			{ rel .. ":" .. entry.lnum, "TelescopeResultsLineNr" },
		})
	end

	pickers
		.new({}, {
			prompt_title = "Workspace Symbols",
			finder = finders.new_table({
				results = symbols,
				entry_maker = function(sym)
					local pkg = resolve_package(sym.file, root)
					return {
						value = sym,
						display = make_display,
						ordinal = sym.name .. " " .. sym.kind .. " " .. (pkg or ""),
						filename = sym.file,
						lnum = sym.lnum,
						col = sym.col or 1,
						name = sym.name,
						kind = sym.kind,
						package = pkg,
						file = sym.file,
					}
				end,
			}),
			sorter = conf.generic_sorter({}),
			previewer = conf.grep_previewer({}),
			attach_mappings = function(prompt_bufnr)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local sel = action_state.get_selected_entry()
					if sel then
						vim.cmd("edit " .. vim.fn.fnameescape(sel.filename))
						vim.api.nvim_win_set_cursor(0, { sel.lnum, (sel.col or 1) - 1 })
						vim.cmd("normal! zz")
					end
				end)
				return true
			end,
		})
		:find()
end

-- ── Public API ───────────────────────────────────────────────────

--- Full index: scan workspace with treesitter, merge LSP, open picker
function M.search(query)
	query = query or ""
	local root = find_workspace_root()

	vim.notify("indexing " .. root .. " …", vim.log.levels.INFO)

	-- 1. treesitter scan (sync, cached)
	local files = collect_files(root)
	local ts_symbols = {}
	for _, f in ipairs(files) do
		local syms = scan_file(f)
		if syms then
			vim.list_extend(ts_symbols, syms)
		end
	end

	-- 2. LSP symbols (async), then merge + show
	fetch_lsp_symbols(query, function(lsp_symbols)
		vim.schedule(function()
			local merged = merge_symbols(ts_symbols, lsp_symbols)

			-- filter by query if provided
			if query ~= "" then
				local q = query:lower()
				merged = vim.tbl_filter(function(s)
					return s.name:lower():find(q, 1, true)
				end, merged)
			end

			-- sort: kind weight then alpha
			table.sort(merged, function(a, b)
				if a.kind ~= b.kind then
					return a.kind < b.kind
				end
				return a.name < b.name
			end)

			vim.notify(string.format("symbol index: %d symbols from %d files", #merged, #files), vim.log.levels.INFO)
			open_picker(merged, root)
		end)
	end)
end

--- Invalidate cache for a file (call on BufWritePost)
function M.invalidate(filepath)
	cache[filepath] = nil
end

--- Clear entire cache
function M.clear()
	cache = {}
	vim.notify("symbol index: cache cleared", vim.log.levels.INFO)
end

--- Get cached symbol count (for statusline, etc.)
function M.stats()
	local file_count = 0
	local sym_count = 0
	for _, entry in pairs(cache) do
		file_count = file_count + 1
		sym_count = sym_count + #entry.symbols
	end
	return { files = file_count, symbols = sym_count }
end

-- ── Commands & autocmds ──────────────────────────────────────────
function M.setup()
	vim.api.nvim_create_user_command("SymbolIndex", function(opts)
		M.search(opts.args ~= "" and opts.args or nil)
	end, { nargs = "?", desc = "Global workspace symbol search (TS + LSP)" })

	vim.api.nvim_create_user_command("SymbolIndexClear", function()
		M.clear()
	end, { desc = "Clear symbol index cache" })

	-- auto-invalidate on save
	vim.api.nvim_create_autocmd("BufWritePost", {
		group = vim.api.nvim_create_augroup("SymbolIndexInvalidate", { clear = true }),
		pattern = { "*.lua", "*.py", "*.ts", "*.tsx", "*.js", "*.jsx", "*.go", "*.rs" },
		callback = function(args)
			local fname = vim.api.nvim_buf_get_name(args.buf)
			if fname ~= "" then
				M.invalidate(fname)
			end
		end,
		desc = "symbol_index: invalidate cache on save",
	})

	-- keymap
	vim.keymap.set("n", "<leader>sS", function()
		M.search()
	end, { desc = "Symbol Index: workspace search" })

	vim.keymap.set("n", "<leader>ss", function()
		local word = vim.fn.expand("<cword>")
		M.search(word)
	end, { desc = "Symbol Index: search word under cursor" })
end

return M
