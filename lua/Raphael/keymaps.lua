local M = {}

local map = vim.keymap.set
local tbl_deep_extend = vim.tbl_deep_extend

local theme_picker = require("Raphael.scripts.picker")
local theme_cycler = require("Raphael.scripts.cycler")
local theme_preview = require("Raphael.scripts.preview")
local theme_loader = require("Raphael.scripts.loader")

local default_keymaps = {
  theme_picker = "<leader>ts",
  cycle_next = "<leader>tn",
  cycle_prev = "<leader>tp",
  random_theme = "<leader>tr",
  preview_themes = "<leader>tP",
  toggle_auto_theme = "<leader>tt",
}

function M.setup(user_keymaps)
  local keymaps = tbl_deep_extend("force", default_keymaps, user_keymaps or {})

  if keymaps.theme_picker then
    map("n", keymaps.theme_picker, theme_picker.select_theme, {
      desc = "Open theme picker",
    })
  end

  if keymaps.cycle_next then
    map("n", keymaps.cycle_next, theme_cycler.cycle_next_theme, {
      desc = "Cycle to next theme",
    })
  end

  if keymaps.cycle_prev then
    map("n", keymaps.cycle_prev, theme_cycler.cycle_prev_theme, {
      desc = "Cycle to previous theme",
    })
  end

  if keymaps.random_theme then
    map("n", keymaps.random_theme, theme_cycler.random_theme, {
      desc = "Set random theme",
    })
  end

  if keymaps.preview_themes then
    map("n", keymaps.preview_themes, function() theme_preview.preview_all_themes() end, {
      desc = "Preview all themes",
    })
  end

  if keymaps.toggle_auto_theme then
    map("n", keymaps.toggle_auto_theme, theme_loader.toggle_auto_theme, {
      desc = "Toggle auto theme switching", silent = true,
    })
  end
end

function M.get_defaults() return vim.deepcopy(default_keymaps) end

return M
