local M = {}
-- Set your default theme here
M.default = "default"
-- Per-filetype themes
M.filetype_themes = {
  markdown = "gruvbox",
  python   = "catppuccin",
  lua      = "onedark",
}

-- Apply a theme safely
local function apply(theme)
  if not theme then return end
  local ok = pcall(vim.cmd.colorscheme, theme)
  if not ok then
    vim.notify("Theme '" .. theme .. "' not found", vim.log.levels.WARN)
  end
end

-- Decide and apply appropriate theme
local function set_theme(bufnr)
  local ft = vim.bo[bufnr].filetype
  local theme = M.filetype_themes[ft] or M.default
  apply(theme)
end

function M.setup()
  -- Set default theme at startup
  apply(M.default)

  -- Change theme on buffer enter
  vim.api.nvim_create_autocmd("BufEnter", {
    callback = function(args)
      set_theme(args.buf)
    end,
  })
end

return M
