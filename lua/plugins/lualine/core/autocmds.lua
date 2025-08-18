local api = vim.api
local defer_fn = vim.defer_fn
local schedule_wrap = vim.schedule_wrap
local loop = vim.loop
local cache = require("plugins.lualine.utils.cache")
local lualine = require("lualine")
local theme = require("plugins.lualine.core.theme")

local group = api.nvim_create_augroup("LualineRefresh", { clear = true })

api.nvim_create_autocmd({ "LspAttach", "LspDetach" }, {
  group = group,
  callback = function()
    cache.invalidate("lsp_clients")
    defer_fn(function()
      lualine.refresh()
    end, 500)
  end,
})

api.nvim_create_autocmd("ColorScheme", {
  group = group,
  callback = function()
    defer_fn(function()
      require("plugins.lualine.core.options").theme = theme.get_lualine_theme()
      lualine.setup(require("plugins.lualine.core.options"))
      lualine.refresh()
    end, 100)
  end,
})

-- Timer-based cache invalidation
local timer = loop.new_timer()
if timer then
  timer:start(60000, 60000, schedule_wrap(function()
    cache.invalidate("test_status")
    cache.invalidate("debug_status")

    lualine.refresh()
  end))
end
