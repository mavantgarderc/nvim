if #vim.api.nvim_list_uis() == 0 then return { setup = function() end } end

local M = {}

function M.setup(capabilities)
  vim.defer_fn(function()
    local ok, lspconfig = pcall(require, "lspconfig")
    if not ok then
      vim.notify("[lsp.servers.html] nvim-lspconfig not found", vim.log.levels.WARN)
      return
    end

    local config_ok = pcall(require, "lspconfig.server_configurations.html")
    if not config_ok then
      vim.notify("[lsp.servers.html] html configuration not available", vim.log.levels.WARN)
      return
    end

    local setup_ok, err = pcall(
      function()
        lspconfig.html.setup({
          capabilities = capabilities,
          filetypes = { "html", "templ" },
          settings = {
            html = {
              format = {
                templating = true,
                wrapLineLength = 120,
                wrapAttributes = "auto",
              },
              hover = {
                documentation = true,
                references = true,
              },
              inlayHints = {
                chainingHints = true,
                parameterHints = true,
              },
            },
          },
        })
      end
    )

    if not setup_ok then vim.notify("[lsp.servers.html] Setup failed: " .. tostring(err), vim.log.levels.WARN) end
  end, 100)
end

return M
