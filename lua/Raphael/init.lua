local M = {}

local themes   = require("Raphael.themes")
local autocmds = require("Raphael.autocmds")
local keymaps  = require("Raphael.keymaps")
local commands = require("Raphael.commands")
local cache    = require("Raphael.cache")

M.state = {
  enabled      = false,
  current      = "kanagawa-paper-ink",
  previous     = nil,
  history      = {},
  bookmarks    = {},
}

-- setup function
function M.setup(opts)
  opts = opts or {}

  -- load user config from ~/raphael.lua if present
  local home_config = vim.fn.expand("~") .. "/raphael.lua"
  if vim.fn.filereadable(home_config) == 1 then
    local ok, user_cfg = pcall(dofile, home_config)
    if ok and type(user_cfg) == "table" then
      themes.merge_user_config(user_cfg)
    end
  else
    -- auto-create template if missing
    local f = io.open(home_config, "w")
    if f then
      f:write([[
-- File: ~/raphael.lua
-- Raphael user preferences
-- You can override mappings or add filetype themes here.

return {
  -- Example:
  -- filetype_themes = {
  --   rust = "gruvbox",
  --   go   = "carbonfox",
  -- },
}
]])
      f:close()
    end
  end

  -- restore state from JSON
  cache.load_state(M.state)

  -- setup autocmds for filetype switching
  autocmds.setup(M)

  -- setup keymaps and commands
  keymaps.setup(M)
  commands.setup(M)
end

-- apply a theme
function M.apply(theme, opts)
  opts = opts or {}
  if not themes.is_available(theme) then
    vim.notify("Raphael: theme " .. theme .. " not available", vim.log.levels.ERROR)
    return
  end

  M.state.previous = vim.g.colors_name
  local ok, err = pcall(vim.cmd.colorscheme, theme)
  if not ok then
    vim.notify("Raphael failed to apply theme: " .. err, vim.log.levels.ERROR)
    vim.cmd.colorscheme("kanagawa-paper-ink")
    return
  end

  M.state.current = theme
  cache.add_history(theme, M.state)
  cache.save_state(M.state)
end

-- toggle auto-theme
function M.toggle()
  M.state.enabled = not M.state.enabled
  vim.notify("Raphael auto-theme " .. (M.state.enabled and "enabled" or "disabled"))
  cache.save_state(M.state)
end

-- picker entry point
function M.pick()
  require("Raphael.picker").open(M)
end

-- bookmarks
function M.toggle_bookmark(theme)
  cache.toggle_bookmark(theme, M.state)
end

return M
