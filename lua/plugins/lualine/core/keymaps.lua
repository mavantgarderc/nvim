-- Keymaps for toggling lualine features

local map = vim.keymap.set
local notify = vim.notify
local log = vim.log
local g = vim.g
local lualine = require("lualine")
local options = require("plugins.lualine.core.options")
local theme = require("plugins.lualine.core.theme")

local show_filetype_text = false

map("n", "<leader>tf", function()
  show_filetype_text = not show_filetype_text
  lualine.refresh()
end, { silent = true, desc = "Toggle filetype text in lualine" })

map("n", "<leader>tl", function()
  local new_theme = theme.get_lualine_theme()
  local current_colorscheme = g.colors_name or "default"
  notify("Scheme: " .. current_colorscheme .. " → Lualine: " .. new_theme, log.levels.INFO)
  options.theme = new_theme
  lualine.setup(options)
  lualine.refresh()
end, { silent = true, desc = "Reload lualine theme" })
