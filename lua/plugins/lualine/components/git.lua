local fn = vim.fn
local glyphs = require("plugins.lualine.utils.glyphs")

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

return M
