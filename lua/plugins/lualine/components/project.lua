local fn = vim.fn

local cache = require("plugins.lualine.utils.cache")

local M = {}

function M.project()
  return cache.get("project", function()
    local root = fn.system("git rev-parse --show-toplevel 2>/dev/null")
    if fn.v.shell_error == 0 and root ~= "" then
      return " " .. fn.fnamemodify(root:gsub("%s+$", ""), ":t")
    end
    return " " .. fn.fnamemodify(fn.getcwd(), ":t")
  end, 15000) -- 15s TTL
end

return M
