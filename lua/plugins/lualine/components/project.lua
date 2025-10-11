local cache = require("plugins.lualine.utils.cache")

local M = {}

function M.project()
  return cache.get("project", function()
    local root = vim.fn.system("git rev-parse --show-toplevel 2>/dev/null")
    if vim.fn.v.shell_error == 0 and root ~= "" then return " " .. vim.fn.fnamemodify(root:gsub("%s+$", ""), ":t") end
    return " " .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
  end, 15000) -- 15s TTL
end

return M
