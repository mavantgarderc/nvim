local fn = vim.fn
local glyphs = require("plugins.lualine.utils.glyphs")
local cache = require("plugins.lualine.utils.cache")

local M = {}

local hide_in_width = function() return fn.winwidth(0) > 80 end

M.branch = {
  "branch",
  icons_enabled = true,
  --icon = glyphs.git.branch_alt,
  icon = glyphs.git.branch,
  cond = function()
    return fn.executable("git") == 1
        and (fn.isdirectory(".git") == 1 or
          fn.system("git rev-parse --git-dir 2>/dev/null"):match("%.git"))
  end,
  fmt = function(str)
    if str == "" or str == nil then return "" end
    return str
  end,
}

M.diff = {
  "diff",
  colored = true,
  symbols = {
    added = glyphs.git.added,
    modified = glyphs.git.modified,
    removed = glyphs.git.removed
  },
  cond = hide_in_width,
}

M.last_commit = function()
  return cache.get_cached_value("last_commit", function()
    local out = vim.fn.system("git rev-parse --short HEAD 2>/dev/null"):gsub("%s+$","")
    return out ~= "" and ("(" .. out .. ")") or ""
  end, 60000)
end

M.ahead_behind = function()
  return cache.get_cached_value("git_aheadbehind", function()
    local out = vim.fn.system("git rev-list --left-right --count @{upstream}...HEAD 2>/dev/null")
    if vim.v.shell_error ~= 0 or out == "" then return "" end
    local behind, ahead = out:match("^(%d+)%s+(%d+)")
    if not behind then return "" end
    behind, ahead = tonumber(behind), tonumber(ahead)
    local parts = {}
    if ahead  > 0 then table.insert(parts, "↑" .. ahead) end
    if behind > 0 then table.insert(parts, "↓" .. behind) end
    return #parts > 0 and table.concat(parts, " ") or ""
  end, 15000)
end

return M
