local M = {}

local show_filetype_text = false

M.filetype = function()
  local ft = vim.bo.filetype
  if ft == "" then return "" end
  local icon, _ = require("nvim-web-devicons").get_icon_by_filetype(ft, { default = true })
  return show_filetype_text and (icon .. " " .. ft) or icon
end

M.toggle_filetype_text = function()
  show_filetype_text = not show_filetype_text
end

return M
