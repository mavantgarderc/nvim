local M = {}

local theme_loader = require("Raphael.scripts.loader")
local api = vim.api

local theme_augroup = nil

-- === Setup Autocmds ===
function M.setup()
  -- Clear existing autocmds if they exist
  if theme_augroup then api.nvim_del_augroup_by_id(theme_augroup) end

  theme_augroup = api.nvim_create_augroup("ThemePicker", { clear = true })

  -- Auto-set theme based on filetype
  api.nvim_create_autocmd("FileType", {
    group = theme_augroup,
    desc = "Set theme based on filetype",
    callback = function(args) theme_loader.set_theme_by_filetype(args.buf) end,
  })

  -- Auto-set theme when entering a buffer
  api.nvim_create_autocmd("BufEnter", {
    group = theme_augroup,
    desc = "Set theme when entering buffer",
    callback = function(args)
      if api.nvim_buf_get_option(args.buf, "buflisted") then theme_loader.set_theme_by_filetype(args.buf) end
    end,
  })
end

-- === Cleanup ===
function M.cleanup()
  if theme_augroup then
    api.nvim_del_augroup_by_id(theme_augroup)
    theme_augroup = nil
  end
end

return M
