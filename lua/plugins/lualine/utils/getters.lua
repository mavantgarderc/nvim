local cache = require("plugins.lualine.utils.cache")
local glyphs = require("plugins.lualine.utils.glyphs")

local M = {}

function M.get_lsp_clients()
  return cache.get_cached_value("lsp_clients", function()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    if #clients == 0 then return "" end

    local names = {}
    for _, client in pairs(clients) do
      table.insert(names, client.name)
    end
    return " " .. table.concat(names, ",")
  end, 10000) -- cache: 10 sec
end

function M.get_python_env()
  return cache.get_cached_value("python_env", function()
    local venv = os.getenv("VIRTUAL_ENV")
    if venv then return glyphs.language.python .. vim.fn.fnamemodify(venv, ":t") end

    local conda_env = os.getenv("CONDA_DEFAULT_ENV")
    if conda_env and conda_env ~= "base" then return glyphs.language.python .. conda_env end

    return ""
  end, 30000) -- cache: 30 sec
end

function M.get_dotnet_project()
  return cache.get_cached_value("dotnet_project", function()
    local cwd = vim.fn.getcwd()
    local sln_files = vim.fn.glob(cwd .. "/*.sln", false, true)
    local csproj_files = vim.fn.glob(cwd .. "/**/*.csproj", false, true)

    if #sln_files > 0 then
      return glyphs.language.dotnet .. vim.fn.fnamemodify(sln_files[1], ":t:r")
    elseif #csproj_files > 0 then
      return glyphs.language.dotnet .. vim.fn.fnamemodify(csproj_files[1], ":t:r")
    end

    return ""
  end, 60000) -- cache: 60 sec
end

function M.get_test_status()
  return cache.get_cached_value("test_status", function()
    local pytest_job = vim.fn.system("pgrep -f pytest 2>/dev/null")
    if pytest_job ~= "" and vim.v.shell_error == 0 then return glyphs.status.test .. " pytest" end

    local dotnet_job = vim.fn.system('pgrep -f "dotnet test" 2>/dev/null')
    if dotnet_job ~= "" and vim.v.shell_error == 0 then return glyphs.status.test .. " dotnet" end

    return ""
  end, 15000) -- cache: 15 sec
end

function M.get_debug_status()
  return cache.get_cached_value("debug_status", function()
    local ok, dap = pcall(require, "dap")
    if ok then
      local session = dap.session()
      if session then
        local breakpoints = require("dap.breakpoints").get()
        local bp_count = 0
        for _, _ in pairs(breakpoints) do
          bp_count = bp_count + 1
        end
        return glyphs.status.debug .. session.adapter.name .. " (" .. bp_count .. " bp)"
      end
    end
    return ""
  end, 5000) -- cache: 5 sec
end

function M.get_database_status()
  local ft = vim.bo.filetype
  if ft == "sql" or ft == "mysql" or ft == "postgresql" then return glyphs.language.database .. "DB" end
  return ""
end

function M.get_cwd()
  local cwd = vim.fn.getcwd()
  local home = os.getenv("HOME")
  if home and cwd:sub(1, #home) == home then cwd = "~" .. cwd:sub(#home + 1) end
  return glyphs.file.folder .. vim.fn.pathshorten(cwd)
end

function M.get_file_info()
  local get_type = vim.bo.filetype ~= "" and vim.bo.filetype or "no ft"
  return string.format("%s", get_type)
end

function M.get_navic_breadcrumbs()
  local ok, navic = pcall(require, "nvim-navic")
  if ok and navic.is_available() then return navic.get_location() end
  return ""
end

function M.get_current_symbol()
  return cache.get_cached_value("current_symbol", function()
    local ok, ts_utils = pcall(require, "nvim-treesitter.ts_utils")
    if not ok then return "" end

    local current_node = ts_utils.get_node_at_cursor()
    if not current_node then return "" end

    local function_node = current_node
    while function_node do
      local node_type = function_node:type()
      if
        node_type == "function_definition"
        or node_type == "method_definition"
        or node_type == "function_declaration"
        or node_type == "method_declaration"
      then
        local name_node = function_node:field("name")[1]
        if name_node then
          local name = vim.treesitter.get_node_text(name_node, 0)
          return glyphs.status.func .. name
        end
        break
      end
      function_node = function_node:parent()
    end
    return ""
  end, 200) -- cache: 0.2 sec
end

return M
