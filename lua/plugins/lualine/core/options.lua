local M = {}

local function get_lualine_theme()
  local colorscheme = vim.g.colors_name or "default"

  local success = pcall(function()
    require("lualine.themes." .. colorscheme)
  end)

  if success then
    return colorscheme
  end

  return
end

M.get_options = function()
  return {
    icons_enabled = true,
    theme = get_lualine_theme(),
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    disabled_filetypes = {
      statusline = { "alpha", "dashboard", "lazy", "TelescopePrompt" },
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    always_show_tabline = true,
    globalstatus = false,
    refresh = {
      statusline = 5000,
      tabline = 5000,
      winbar = 5000,
    },
  }
end

M.get_lualine_theme = get_lualine_theme

return M
