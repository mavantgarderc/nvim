local getters = require("plugins.lualine.utils.getters")

local M = {}

M.has_lsp = function()
	return #vim.lsp.get_clients({ bufnr = 0 }) > 0
end

M.has_python_env = function()
	return getters.get_python_env() ~= ""
end

M.has_dotnet_project = function()
	return getters.get_dotnet_project() ~= ""
end

M.has_test_running = function()
	return getters.get_test_status() ~= ""
end

M.has_debug_session = function()
	return getters.get_debug_status() ~= ""
end

M.has_symbol = function()
	return getters.get_current_symbol() ~= ""
end

M.is_sql_file = function()
	local ft = vim.bo.filetype
	return ft == "sql" or ft == "mysql" or ft == "postgresql"
end

M.has_navic = function()
	local ok, navic = pcall(require, "nvim-navic")
	return ok and navic.is_available()
end

return M
