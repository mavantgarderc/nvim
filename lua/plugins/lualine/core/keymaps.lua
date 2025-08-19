local map = vim.keymap.set
local notify = vim.notify
local log = vim.log
local g = vim.g

local M = {}

function M.setup(lualine_opts)
  local components = require("plugins.lualine.components.init")
  local options = require("plugins.lualine.core.options")

  -- === KEYMAPS ===
  map("n", "<leader>tf", function()
    components.toggle_filetype_text()
    require("lualine").refresh()
  end, { silent = true })

  map("n", "<leader>tl", function()
    local new_theme = options.get_lualine_theme()
    local current_colorscheme = g.colors_name or "default"
    notify("Scheme: " .. current_colorscheme .. " → Lualine: " .. new_theme, log.levels.INFO)
    lualine_opts.options.theme = new_theme
    require("lualine").setup(lualine_opts)
    require("lualine").refresh()
  end, { silent = true })
end

return M
