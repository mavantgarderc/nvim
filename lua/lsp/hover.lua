local M = {}

local ns = vim.api.nvim_create_namespace("lsp_hover")

--- @type table<integer, { lines: string[], clients: string[], ts: number }>
M._cache = {}

--- @type table<integer, integer>
M._pin_bufs = {}

M.config = {
	border = "rounded",
	max_width = 80,
	max_height = 30,
	pin_timeout_ms = 0, -- 0 = no auto-close
	merge_clients = true,
}

local setup_done = false

--- Merge hover results from all attached clients
--- @param bufnr integer
--- @param callback fun(lines: string[], clients: string[])
function M._gather_hover(bufnr, callback)
	local clients = vim.lsp.get_clients({ bufnr = bufnr })
	if #clients == 0 then
		callback({}, {})
		return
	end

	local results = {}
	local client_names = {}
	local pending = #clients
	local params = vim.lsp.util.make_position_params()

	for _, client in ipairs(clients) do
		if client.supports_method("textDocument/hover") then
			client.request("textDocument/hover", params, function(err, result)
				if not err and result and result.contents then
					local text = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
					if #text > 0 then
						table.insert(results, { name = client.name, lines = text })
						table.insert(client_names, client.name)
					end
				end
				pending = pending - 1
				if pending == 0 then
					if #results == 0 then
						callback({}, {})
						return
					end

					if not M.config.merge_clients then
						callback(vim.deepcopy(results[1].lines), { results[1].name })
						return
					end

					local merged = {}
					for i, r in ipairs(results) do
						if i > 1 then
							table.insert(merged, "---")
							table.insert(merged, "")
						end
						if #results > 1 then
							table.insert(merged, "**[" .. r.name .. "]**")
							table.insert(merged, "")
						end
						vim.list_extend(merged, r.lines)
					end
					callback(merged, client_names)
				end
			end, bufnr)
		else
			pending = pending - 1
			if pending == 0 then
				callback({}, {})
			end
		end
	end
end

--- Show hover in a styled floating window
--- @param opts? { pin?: boolean }
function M.hover(opts)
	opts = opts or {}
	local bufnr = vim.api.nvim_get_current_buf()

	M._gather_hover(bufnr, function(lines, clients)
		if #lines == 0 then
			vim.notify("No hover info", vim.log.levels.INFO)
			return
		end

		M._cache[bufnr] = { lines = lines, clients = clients, ts = vim.uv.now() }

		local float_buf, win = vim.lsp.util.open_floating_preview(lines, "markdown", {
			border = M.config.border,
			max_width = M.config.max_width,
			max_height = M.config.max_height,
			focus_id = "lsp_hover",
		})

		if opts.pin and float_buf then
			M._pin_bufs[bufnr] = float_buf
			-- Keep pinned windows open until the user closes or unpins them.
			if win and vim.api.nvim_win_is_valid(win) then
				vim.api.nvim_win_set_config(win, { focusable = true })
			end
			if M.config.pin_timeout_ms > 0 then
				vim.defer_fn(function()
					M.unpin(bufnr)
				end, M.config.pin_timeout_ms)
			end
		end
	end)
end

--- Pin current hover (re-triggers hover with pin=true)
function M.pin()
	M.hover({ pin = true })
end

--- Unpin hover for buffer
--- @param bufnr? integer
function M.unpin(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	local fb = M._pin_bufs[bufnr]
	if fb and vim.api.nvim_buf_is_valid(fb) then
		local wins = vim.fn.win_findbuf(fb)
		for _, w in ipairs(wins) do
			if vim.api.nvim_win_is_valid(w) then
				vim.api.nvim_win_close(w, true)
			end
		end
	end
	M._pin_bufs[bufnr] = nil
end

--- Get cached hover for buffer (if any)
--- @param bufnr? integer
--- @return { lines: string[], clients: string[], ts: number }|nil
function M.get_cached(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	return M._cache[bufnr]
end

--- Clear hover cache
--- @param bufnr? integer
function M.clear_cache(bufnr)
	if bufnr then
		M._cache[bufnr] = nil
	else
		M._cache = {}
	end
end

function M.setup(opts)
	M.config = vim.tbl_deep_extend("force", M.config, opts or {})

	if setup_done then
		return
	end

	vim.api.nvim_create_user_command("LspHover", function()
		M.hover()
	end, { desc = "LSP: Enhanced hover" })

	vim.api.nvim_create_user_command("LspHoverPin", function()
		M.pin()
	end, { desc = "LSP: Pin hover window" })

	vim.api.nvim_create_user_command("LspHoverUnpin", function()
		M.unpin()
	end, { desc = "LSP: Unpin hover window" })

	-- cleanup on buffer delete
	local group = vim.api.nvim_create_augroup("LspHover", { clear = true })
	vim.api.nvim_create_autocmd("BufDelete", {
		group = group,
		callback = function(ev)
			M._cache[ev.buf] = nil
			M._pin_bufs[ev.buf] = nil
		end,
	})

	setup_done = true
end

return M
