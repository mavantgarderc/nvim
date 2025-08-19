local g = vim.g

local M = {}

local function get_lualine_theme()
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

function M.get_options()
  return {
    icons_enabled        = true,
    theme                = get_lualine_theme(),
    component_separators = { left = "", right = "" },
    section_separators   = { left = "", right = "" },
    disabled_filetypes   = {
      statusline = { "alpha", "dashboard", "lazy", "TelescopePrompt" },
      winbar = {},
    },
    ignore_focus         = {},
    always_divide_middle = true,
    always_show_tabline  = true,
    globalstatus         = false,
    refresh              = {
      statusline = 5000,
      tabline    = 5000,
      winbar     = 5000,
    },
  }
end

-- Expose the theme function for keymaps
M.get_lualine_theme = get_lualine_theme

return M
