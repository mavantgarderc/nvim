local cache = require("plugins.lualine.utils.cache")
local conditions = require("plugins.lualine.utils.conditions")
local getters = require("plugins.lualine.utils.getters")

local M = {}

M.cache = cache.cache

M.get_lsp_clients = getters.get_lsp_clients
M.get_python_env = getters.get_python_env
M.get_dotnet_project = getters.get_dotnet_project
M.get_test_status = getters.get_test_status
M.get_debug_status = getters.get_debug_status
M.get_database_status = getters.get_database_status
M.get_cwd = getters.get_cwd
M.get_file_info = getters.get_file_info
M.get_navic_breadcrumbs = getters.get_navic_breadcrumbs
M.get_current_symbol = getters.get_current_symbol

M.has_lsp = conditions.has_lsp
M.has_python_env = conditions.has_python_env
M.has_dotnet_project = conditions.has_dotnet_project
M.has_test_running = conditions.has_test_running
M.has_debug_session = conditions.has_debug_session
M.has_symbol = conditions.has_symbol
M.is_sql_file = conditions.is_sql_file
M.has_navic = conditions.has_navic

return M
