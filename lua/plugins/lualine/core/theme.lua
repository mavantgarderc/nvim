local g = vim.g

local M = {}

function M.get_lualine_theme()
  local colorscheme = g.colors_name or "default"
  local theme_map = { require("colors") }
  local mapped_theme = theme_map[colorscheme:lower()]

  if mapped_theme then
    local success = pcall(function() require("lualine.themes." .. mapped_theme) end)
    if success then return mapped_theme end
  end

  local success = pcall(function() require("lualine.themes." .. colorscheme) end)
  if success then return colorscheme end

  return "auto"
end

return M
