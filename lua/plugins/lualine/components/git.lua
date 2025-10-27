local glyphs = require("plugins.lualine.utils.glyphs")
local cache = require("plugins.lualine.utils.cache")

local M = {}

local hide_in_width = function()
  return vim.fn.winwidth(0) > 80
end
local last_commit_enabled = true

M.branch = {
  "branch",
  icons_enabled = true,
  --icon = glyphs.git.branch_alt,
  icon = glyphs.git.branch,
  cond = function()
    return vim.fn.executable("git") == 1 and (vim.fn.isdirectory(".git") == 1 or vim.fn.system("git rev-parse --git-dir 2>/dev/null"):match("%.git"))
  end,
  fmt = function(str)
    if str == "" or str == nil then
      return ""
    end
    return str
  end,
}

M.diff = {
  "diff",
  colored = true,
  symbols = {
    added = glyphs.git.added,
    modified = glyphs.git.modified,
    removed = glyphs.git.removed,
  },
  cond = hide_in_width,
}

M.last_commit = {
  function()
    if not last_commit_enabled then
      return ""
    end
    local handle = io.popen("git rev-parse --short HEAD 2>/dev/null")
    if not handle then
      return ""
    end
    local result = handle:read("*a")
    handle:close()
    result = result:gsub("%s+", "")
    return result ~= "" and "(" .. result .. ")" or ""
  end,
  fmt = function(str)
    return str
  end,
}

M.toggle_last_commit = function()
  last_commit_enabled = not last_commit_enabled
  require("lualine").refresh({ place = { "statusline" } })
end

M.ahead_behind = function()
  return cache.get_cached_value("git_aheadbehind", function()
    local out = vim.fn.system("git rev-list --left-right --count @{upstream}...HEAD 2>/dev/null")
    if vim.v.shell_error ~= 0 or out == "" then
      return ""
    end
    local behind_count, ahead_count = out:match("^(%d+)%s+(%d+)")
    if not behind_count then
      return ""
    end
    behind_count, ahead_count = tonumber(behind_count), tonumber(ahead_count)
    local parts = {}
    if ahead_count > 0 then
      table.insert(parts, glyphs.git.ahead .. ahead_count)
    end
    if behind_count > 0 then
      table.insert(parts, glyphs.git.behind .. behind_count)
    end
    return #parts > 0 and table.concat(parts, " ") or ""
  end, 15000)
end

return M
