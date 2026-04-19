local M = {}

local cache = {}
local CACHE_TTL_MS = 5000

local config = {
	border = "rounded",
	peek = false,
	cache_enabled = true,
}

local commands_registered = false

local function cache_key(bufnr, pos)
	return string.format("%d:%d:%d", bufnr, pos[1], pos[2])
end

local function get_cached(key)
	local entry = cache[key]
	if not entry then
		return nil
	end
	if vim.uv.now() - entry.time > CACHE_TTL_MS then
		cache[key] = nil
		return nil
	end
	return entry.result
end

local function navigate(result, opts)
	local target = vim.islist(result) and result[1] or result
	local uri = target.uri or target.targetUri
	local range = target.range or target.targetSelectionRange
	if not uri or not range then
		return
	end

	local use_peek = opts and opts.peek
	if use_peek == nil then
		use_peek = config.peek
	end

	if use_peek then
		local peek_ok, peek = pcall(require, "lsp.definition_peek")
		if peek_ok and peek.setup then
			peek.setup({ border = config.border })
		end
		if peek_ok and peek.open_location then
			peek.open_location(uri, range, { title = " Type Definition " })
			return
		end
	end

	local fname = vim.uri_to_fname(uri)
	vim.cmd("edit " .. vim.fn.fnameescape(fname))
	vim.api.nvim_win_set_cursor(0, { range.start.line + 1, range.start.character })
end

function M.goto_type(opts)
	opts = opts or {}
	local bufnr = vim.api.nvim_get_current_buf()
	local pos = vim.api.nvim_win_get_cursor(0)
	local key = cache_key(bufnr, pos)

	if config.cache_enabled then
		local cached = get_cached(key)
		if cached then
			navigate(cached, opts)
			return
		end
	end

	local clients = vim.lsp.get_clients({ bufnr = bufnr, method = "textDocument/typeDefinition" })
	if #clients == 0 then
		vim.notify("No LSP client supports typeDefinition", vim.log.levels.WARN)
		return
	end

	local params = vim.lsp.util.make_position_params()
	vim.lsp.buf_request(bufnr, "textDocument/typeDefinition", params, function(err, result, _)
		if err then
			vim.notify("TypeDef: " .. tostring(err.message), vim.log.levels.ERROR)
			return
		end
		if not result or vim.tbl_isempty(result) then
			vim.notify("No type definition found", vim.log.levels.INFO)
			return
		end
		if config.cache_enabled then
			cache[key] = { result = result, time = vim.uv.now() }
		end
		navigate(result, opts)
	end)
end

function M.clear_cache()
	cache = {}
end

function M.setup(opts)
	config = vim.tbl_deep_extend("force", config, opts or {})

	if commands_registered then
		return
	end

	vim.api.nvim_create_user_command("LspTypeDefinition", function()
		M.goto_type()
	end, { desc = "Jump to the type definition under cursor" })

	vim.api.nvim_create_user_command("LspTypePeek", function()
		M.goto_type({ peek = true })
	end, { desc = "Peek the type definition under cursor" })

	commands_registered = true
end

return M
