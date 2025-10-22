if #vim.api.nvim_list_uis() == 0 then
  return { setup = function() end }
end

local M = {}

function M.setup(capabilities)
  vim.defer_fn(function()
    local ok, lspconfig = pcall(require, "lspconfig")
    if not ok then
      vim.notify("[lsp.servers.css] nvim-lspconfig not found", vim.log.levels.WARN)
      return
    end

    local config_ok = pcall(require, "lspconfig.server_configurations.cssls")
    if not config_ok then
      vim.notify("[lsp.servers.css] cssls configuration not available", vim.log.levels.WARN)
      return
    end

    local setup_ok, err = pcall(function()
      lspconfig.cssls.setup({
        capabilities = capabilities,
        settings = {
          css = {
            validate = true,
            lint = { unknownAtRules = "ignore" },
          },
          scss = {
            validate = true,
            lint = { unknownAtRules = "ignore" },
          },
          less = {
            validate = true,
            lint = { unknownAtRules = "ignore" },
          },
        },
      })
    end)

    if not setup_ok then
      vim.notify("[lsp.servers.css] Setup failed: " .. tostring(err), vim.log.levels.WARN)
    end
  end, 100)
end

return M
