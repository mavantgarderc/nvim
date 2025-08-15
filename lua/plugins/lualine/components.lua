local fn, bo, v, treesitter = vim.fn, vim.bo, vim.v, vim.treesitter
local cache = require("plugins.lualine.cache")
local utils = require("plugins.lualine.utils")

local M = {}
local show_filetype_text = false

M.diagnostics = {
  "diagnostics",
  sources = { "nvim_diagnostic" },
  sections = { "error", "warn" },
  symbols = { error = "󰯈 ", warn = " " },
  colored = false,
  update_in_insert = false,
  always_visible = true,
}

M.diff = {
  "diff",
  colored = true,
  symbols = { added = " ", modified = " ", removed = " " },
  cond = utils.hide_in_width,
}

M.branch = {
  "branch",
  icons_enabled = true,
  icon = "󰝨",
  cond = function()
    return fn.executable("git") == 1 and (
      fn.isdirectory(".git") == 1 or
      fn.system("git rev-parse --git-dir 2>/dev/null"):match("%.git")
    )
  end,
  fmt = function(str) return (str and str ~= "") and str or "" end,
}

M.location = { "location", padding = 0 }

M.progress = function()
  local chars = {
    "", "", "", "", "", "", "", "", "", "",
    "", "", "", "", "", "", "", "", "", "",
  }
  local current_line = fn.line(".")
  local total_lines = fn.line("$")
  local index = math.ceil((current_line / total_lines) * #chars)
  return chars[index] or chars[#chars]
end

M.filetype = function()
  local ft = bo.filetype
  if ft == "" then return "" end
  local icon, _ = require("nvim-web-devicons").get_icon_by_filetype(ft, { default = true })
  return show_filetype_text and (icon .. " " .. ft) or icon
end

M.get_lsp_clients = function()
  return cache.get("lsp_clients", function()
    local clients = vim.lsp.get_clients({ bufnr = 0 })
    if #clients == 0 then return "" end
    local names = {}
    for _, client in pairs(clients) do table.insert(names, client.name) end
    return " " .. table.concat(names, ",")
  end, 10000)
end

M.get_python_env = function()
  return cache.get("python_env", function()
    local venv = os.getenv("VIRTUAL_ENV")
    if venv then return " " .. fn.fnamemodify(venv, ":t") end
    local conda_env = os.getenv("CONDA_DEFAULT_ENV")
    if conda_env and conda_env ~= "base" then return " " .. conda_env end
    return ""
  end, 30000)
end

M.get_dotnet_project = function()
  return cache.get("dotnet_project", function()
    local cwd = fn.getcwd()
    local sln_files = fn.glob(cwd .. "/*.sln", false, true)
    local csproj_files = fn.glob(cwd .. "/**/*.csproj", false, true)
    if #sln_files > 0 then return " " .. fn.fnamemodify(sln_files[1], ":t:r") end
    if #csproj_files > 0 then return " " .. fn.fnamemodify(csproj_files[1], ":t:r") end
    return ""
  end, 60000)
end

M.get_test_status = function()
  return cache.get("test_status", function()
    if fn.system("pgrep -f pytest 2>/dev/null") ~= "" and v.shell_error == 0 then return "󰙨 pytest" end
    if fn.system("pgrep -f \"dotnet test\" 2>/dev/null") ~= "" and v.shell_error == 0 then return "󰙨 dotnet" end
    return ""
  end, 15000)
end

M.get_debug_status = function()
  return cache.get("debug_status", function()
    local ok, dap = pcall(require, "dap")
    if ok then
      local session = dap.session()
      if session then
        local breakpoints = require("dap.breakpoints").get()
        local bp_count = 0
        for _ in pairs(breakpoints) do bp_count = bp_count + 1 end
        return " " .. session.adapter.name .. " (" .. bp_count .. " bp)"
      end
    end
    return ""
  end, 5000)
end

M.get_database_status = function()
  if utils.is_sql_file() then return " DB" end
  return ""
end

M.get_file_info = function()
  return bo.filetype ~= "" and bo.filetype or "no ft"
end

M.get_navic_breadcrumbs = function()
  local ok, navic = pcall(require, "nvim-navic")
  if ok and navic.is_available() then return navic.get_location() end
  return ""
end

M.get_current_symbol = function()
  return cache.get("current_symbol", function()
    local ok, ts_utils = pcall(require, "nvim-treesitter.ts_utils")
    if not ok then return "" end
    local node = ts_utils.get_node_at_cursor()
    while node do
      local nt = node:type()
      if nt:match("function") or nt:match("method") then
        local name_node = node:field("name")[1]
        if name_node then
          return "⚡" .. treesitter.get_node_text(name_node, 0)
        end
        break
      end
      node = node:parent()
    end
    return ""
  end, 200)
end

return M
