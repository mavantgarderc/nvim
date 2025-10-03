local M = {}

function M.setup(lualine_opts)
  local utils = require("plugins.lualine.utils.init")
  local options = require("plugins.lualine.core.options")

  local group = vim.api.nvim_create_augroup("LualineRefresh", { clear = true })

  vim.api.nvim_create_autocmd({ "LspAttach", "LspDetach" }, {
    group = group,
    callback = function()
      utils.cache.lsp_clients = { value = "", last_update = 0 }
      vim.defer_fn(function()
        require("lualine").refresh()
      end, 500)
    end,
  })

  vim.api.nvim_create_autocmd("ColorScheme", {
    group = group,
    callback = function()
      vim.defer_fn(function()
        lualine_opts.options.theme = options.get_lualine_theme()
        require("lualine").setup(lualine_opts)
        require("lualine").refresh()
      end, 100)
    end,
  })

  local timer = vim.loop.new_timer()
  if timer then
    timer:start(60000, 60000, vim.schedule_wrap(function()
      utils.cache.test_status  = { value = "", last_update = 0 }
      utils.cache.debug_status = { value = "", last_update = 0 }

      if utils.has_test_running() or utils.has_debug_session() then
        require("lualine").refresh()
      end
    end))
  end
end

return M
