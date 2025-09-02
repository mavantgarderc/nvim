local fn = vim.fn
local v = vim.v

local M = {}

local cache = require("plugins.lualine.utils.cache")

local patterns = {
  "dotnet build", "dotnet test",
  "make", "ninja",
  "npm run build", "pnpm build", "yarn build",
}

function M.build_status()
  return cache.get("build_status", function()
    for _, p in ipairs(patterns) do
      local out = fn.system("pgrep -f '" .. p .. "' 2>/dev/null")
      if out ~= "" and v.shell_error == 0 then
        return "󰣖 BUILD"
      end
    end
    return ""
  end, 3000)
end

return M
