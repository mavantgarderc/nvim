-- ============================================================================
-- Theme Configuration — ui/themes.lua
-- ============================================================================
-- Apply colorschemes based solely on filetype, with a manual toggle
-- ============================================================================

-- Function to set theme based on current buffer’s filetype
local function set_theme_for_filetype()
  local ft = vim.bo.filetype
  if ft == "python" then
    vim.cmd.colorscheme("dracula")
  elseif ft == "lua" then
    vim.cmd.colorscheme("gruvbox")
  elseif ft == "typescript" then
    vim.cmd.colorscheme("nord")
  else
    -- Default theme if no filetype match
    vim.cmd.colorscheme("gruvbox")
  end
end

-- Apply filetype-based theme on each buffer enter
vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("FiletypeTheme", { clear = true }),
  pattern = "*",
  callback = set_theme_for_filetype,
})

-- Manual toggle between primary themes
vim.keymap.set("n", "<leader>tt", function()
  local current = vim.g.colors_name or ""
  if current == "dracula" then
    vim.cmd.colorscheme("gruvbox")
  elseif current == "nord" then
    vim.cmd.colorscheme("gruvbox")
  else
    vim.cmd.colorscheme("dracula")
  end
end, { desc = "Toggle Theme (dracula ↔ gruvbox)" })
