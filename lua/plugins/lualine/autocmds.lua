local api = vim.api
local defer_fn = vim.defer_fn
local loop = vim.loop
local schedule_wrap = vim.schedule_wrap

local cache = require("plugins.lualine.cache")
local utils = require("plugins.lualine.utils")

local M = {}

function M.setup(opts)
  local group = api.nvim_create_augroup("LualineRefresh", { clear = true })

  api.nvim_create_autocmd({ "LspAttach", "LspDetach" }, {
    group = group,
    callback = function()
      cache.invalidate({ "lsp_clients" })
      defer_fn(function() require("lualine").refresh() end, 500)
    end,
  })

  api.nvim_create_autocmd("ColorScheme", {
    group = group,
    callback = function()
      defer_fn(function()
        opts.options.theme = utils.get_theme()
        require("lualine").setup(opts)
        require("lualine").refresh()
      end, 100)
    end,
  })

  local timer = loop.new_timer()
  if timer then
    timer:start(60000, 60000, schedule_wrap(function()
      cache.invalidate({ "test_status", "debug_status" })
      require("lualine").refresh()
    end))
  end
end

return M
