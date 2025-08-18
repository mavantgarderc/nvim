-- Progress bar component

local fn = vim.fn

local M = {}

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

return M
