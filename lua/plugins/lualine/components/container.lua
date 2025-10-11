local cache = require("plugins.lualine.utils.cache")

local M = {}

function M.container()
  return cache.get("container", function()
    if vim.fn.filereadable("/.dockerenv") == 1 or vim.fn.isdirectory("/run/.containerenv") == 1 then return " docker" end

    local uname = vim.fn.system("uname -r")
    if uname:match("microsoft") then return "󰢹 wsl" end

    return ""
  end, 10000) -- check every 10s
end

return M
