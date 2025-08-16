local M = {}

local api = vim.api

local theme_loader = require("Raphael.scripts.loader")

local theme_augroup = nil

function M.setup()
  if theme_augroup then api.nvim_del_augroup_by_id(theme_augroup) end

  theme_augroup = api.nvim_create_augroup("ThemePicker", { clear = true })

  api.nvim_create_autocmd("FileType", {
    group = theme_augroup,
    desc = "Set theme based on filetype",
    callback = function(args) theme_loader.set_theme_by_filetype(args.buf) end,
  })

  api.nvim_create_autocmd("BufEnter", {
    group = theme_augroup,
    desc = "Set theme when entering buffer",
    callback = function(args)
      if api.nvim_buf_get_option(args.buf, "buflisted") then theme_loader.set_theme_by_filetype(args.buf) end
    end,
  })
end

function M.cleanup()
  if theme_augroup then
    api.nvim_del_augroup_by_id(theme_augroup)
    theme_augroup = nil
  end
end

return M
