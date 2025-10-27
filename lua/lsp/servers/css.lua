if #vim.api.nvim_list_uis() == 0 then
  return { setup = function() end }
end

local M = {}

function M.setup(capabilities)
  vim.defer_fn(function()
    local css_ok, lspconfig = pcall(require, "lspconfig")
    if not css_ok then
      vim.notify("[lsp.servers.css] nvim-lspconfig not found", vim.log.levels.WARN)
      return
    end

    local css_config_ok = pcall(require, "lspconfig.server_configurations.cssls")
    if not css_config_ok then
      vim.notify("[lsp.servers.css] cssls configuration not available", vim.log.levels.WARN)
      return
    end

    local css_setup_ok, err = pcall(function()
      lspconfig.cssls.setup({
        capabilities = capabilities,
        settings = {
          css = {
            validate = true,
            lint = { unknownAtRules = "ignore" },
            inlayHints = {
              chainingHints = true,
              parameterHints = true,
            },
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

    if not css_setup_ok then
      vim.notify("[lsp.servers.css] Setup failed: " .. tostring(err), vim.log.levels.WARN)
    end
  end, 100)
end

return M
