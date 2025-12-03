local cache = require("plugins.lualine.utils.cache")

local M = {}

M.lsp_progress = function()
	local msgs = vim.lsp.util.get_progress_messages()
	if not msgs or #msgs == 0 then
		return ""
	end
	local parts = {}
	for _, m in ipairs(msgs) do
		local pct = m.percentage and (m.percentage .. "%% ") or ""
		local name = m.title or m.message or "LSP"
		table.insert(parts, "⟳ " .. pct .. name)
	end
	return table.concat(parts, " | ")
end

M.lsp_client = function()
	return cache.get_cached_value("lsp_clients", function()
		local clients = vim.lsp.get_clients({ bufnr = 0 })
		if #clients == 0 then
			return ""
		end
		local names = {}
		for _, c in pairs(clients) do
			table.insert(names, c.name)
		end
		return " " .. table.concat(names, ",")
	end, 10000)
end

return M
