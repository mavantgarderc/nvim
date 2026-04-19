local M = {}

local config = {
	strategy = "telescope", -- "telescope" | "quickfix"
	max_results = 100,
	debounce_ms = 200,
}

local commands_registered = false

local function qf_search(query)
	vim.lsp.buf_request(0, "workspace/symbol", { query = query or "" }, function(err, result, _)
		if err then
			vim.notify("Workspace symbol: " .. tostring(err.message), vim.log.levels.ERROR)
			return
		end
		if not result or #result == 0 then
			vim.notify("No symbols found", vim.log.levels.INFO)
			return
		end

		local items = {}
		for i, sym in ipairs(result) do
			if i > config.max_results then
				break
			end
			local loc = sym.location
			table.insert(items, {
				filename = vim.uri_to_fname(loc.uri),
				lnum = loc.range.start.line + 1,
				col = loc.range.start.character + 1,
				text = string.format("[%s] %s", vim.lsp.protocol.SymbolKind[sym.kind] or "?", sym.name),
			})
		end

		vim.fn.setqflist({}, " ", { title = "Workspace Symbols: " .. (query or ""), items = items })
		vim.cmd("copen")
	end)
end

local function telescope_search(query)
	local ok, builtin = pcall(require, "telescope.builtin")
	if not ok then
		vim.notify("Telescope not available, falling back to quickfix", vim.log.levels.WARN)
		qf_search(query)
		return
	end
	builtin.lsp_workspace_symbols({
		query = query or "",
	})
end

function M.search(query)
	local clients = vim.lsp.get_clients({ bufnr = 0, method = "workspace/symbol" })
	if #clients == 0 then
		vim.notify("No LSP client supports workspace/symbol", vim.log.levels.WARN)
		return
	end

	if config.strategy == "telescope" then
		telescope_search(query)
	else
		qf_search(query)
	end
end

function M.prompt()
	vim.ui.input({ prompt = "Workspace symbol: " }, function(input)
		if input and input ~= "" then
			M.search(input)
		end
	end)
end

function M.setup(opts)
	config = vim.tbl_deep_extend("force", config, opts or {})

	if commands_registered then
		return
	end

	vim.api.nvim_create_user_command("LspWorkspaceSymbol", function(cmd)
		if cmd.args ~= "" then
			M.search(cmd.args)
			return
		end
		M.prompt()
	end, { nargs = "?", desc = "Search workspace symbols" })

	commands_registered = true
end

return M
