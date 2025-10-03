local getters = require("plugins.lualine.utils.getters")

local M = {}

function M.has_lsp()
  return #vim.lsp.get_clients({ bufnr = 0 }) > 0
end

function M.has_python_env()
  return getters.get_python_env() ~= ""
end

function M.has_dotnet_project()
  return getters.get_dotnet_project() ~= ""
end

function M.has_test_running()
  return getters.get_test_status() ~= ""
end

function M.has_debug_session()
  return getters.get_debug_status() ~= ""
end

function M.has_symbol()
  return getters.get_current_symbol() ~= ""
end

function M.is_sql_file()
  local ft = vim.bo.filetype
  return ft == "sql" or ft == "mysql" or ft == "postgresql"
end

function M.has_navic()
  local ok, navic = pcall(require, "nvim-navic")
  return ok and navic.is_available()
end

return M
