local map = vim.keymap.set
local g = vim.g
local notify = vim.notify
local log = vim.log

local utils = require("plugins.lualine.utils")

local M = {}

local show_filetype_text = false

function M.setup(opts)
  map("n", "<leader>tf", function()
    show_filetype_text = not show_filetype_text
    require("lualine").refresh()
  end, { silent = true })

  map("n", "<leader>tl", function()
    local new_theme = utils.get_theme()
    notify("Scheme: " .. (g.colors_name or "default") .. " → Lualine: " .. new_theme, log.levels.INFO)
    opts.options.theme = new_theme
    require("lualine").setup(opts)
    require("lualine").refresh()
  end, { silent = true })
end

return M
