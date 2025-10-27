if #vim.api.nvim_list_uis() == 0 then return { setup = function() end } end

local M = {}

function M.setup(capabilities)
  vim.defer_fn(function()
    local ok, lspconfig = pcall(require, "lspconfig")
    if not ok then return end

    -- Pre-load the server configuration
    local config_ok = pcall(require, "lspconfig.server_configurations.SERVERNAME")
    if not config_ok then return end

    pcall(function()
      lspconfig.SERVERNAME.setup({
        capabilities = capabilities,
        -- your settings here
      })
    end)
  end, 150) -- Increased delay to ensure lspconfig is ready
end

return M
