local M = {}

local cache = require("plugins.lualine.utils.cache")

M.ci = function()
  return cache.get("ci_status", function()
    local out = vim.fn.system("gh run list --limit 1 --json status,conclusion 2>/dev/null")
    if vim.v.shell_error ~= 0 or out == "" then
      return ""
    end
    local ok, json = pcall(vim.json.decode, out)
    if not ok or not json or not json[1] then
      return ""
    end
    local r = json[1]
    if r.status == "in_progress" or r.status == "queued" then
      return " CI"
    end
    if r.conclusion == "success" then
      return " CI"
    end
    if r.conclusion == "failure" then
      return " CI"
    end
    if r.conclusion == "cancelled" then
      return " CI"
    end
    return ""
  end, 20000)
end

return M
