local fn = vim.fn

local components = require("plugins.lualine.components.init")
local utils = require("plugins.lualine.utils.init")

local M = {}

M.sections = {
  lualine_a = { components.branch },
  lualine_b = { components.diagnostics },
  lualine_c = {
    { utils.get_navic_breadcrumbs,   cond = utils.has_navic },
    { utils.get_current_symbol,      cond = utils.has_symbol },
  },
  lualine_x = {
    components.diff,
    components.ahead_behind,
    components.last_commit,
    components.filetype
  },
  lualine_y = { components.location, "  " },
  lualine_z = { components.progress },
}

M.inactive_sections = {
  lualine_a = {},
  lualine_b = {},
  lualine_c = { "filename" },
  lualine_x = { "location" },
  lualine_y = {},
  lualine_z = { components.progress },
}

M.tabline = {
  lualine_a = { "tabs" },
  lualine_b = { utils.get_cwd },
  lualine_c = { "filename" },
  lualine_x = {},
  lualine_y = {
    utils.get_file_info,
    { utils.get_lsp_clients,     cond = utils.has_lsp },
    { utils.get_python_env,      cond = utils.has_python_env },
    { utils.get_dotnet_project,  cond = utils.has_dotnet_project },
    { utils.get_test_status,     cond = utils.has_test_running },
    { utils.get_debug_status,    cond = utils.has_debug_session },
    { utils.get_database_status, cond = utils.is_sql_file },
    components.ci,
  },
  lualine_z = {
  },
}

M.winbar = {}

M.inactive_winbar = {}

return M
