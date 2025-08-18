-- Misc helpers for lualine components

local fn = vim.fn
local bo = vim.bo

local M = {}

function M.hide_in_width()
  return fn.winwidth(0) > 80
end

function M.cwd()
  local cwd = fn.getcwd()
  local home = os.getenv("HOME")
  if home and cwd:sub(1, #home) == home then
    cwd = "~" .. cwd:sub(#home + 1)
  end
  return " " .. fn.pathshorten(cwd)
end

function M.filetype()
  return bo.filetype
end

return M
