if #vim.api.nvim_list_uis() == 0 then
  return { setup = function() end }
end

local M = {}

function M.setup(capabilities)
  vim.defer_fn(function()
    local python_ok, lspconfig = pcall(require, "lspconfig")
    if not python_ok then
      vim.notify("[lsp.servers.python] nvim-lspconfig not found", vim.log.levels.WARN)
      return
    end

    local python_config_ok = pcall(require, "lspconfig.server_configurations.pyright")
    if not python_config_ok then
      vim.notify("[lsp.servers.python] pyright configuration not available", vim.log.levels.WARN)
      return
    end

    local python_setup_ok, err = pcall(function()
      lspconfig.pyright.setup({
        capabilities = capabilities,
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = "workspace",
              inlayHints = {
                chainingHints = true,
                parameterHints = true,
              },
            },
          },
        },
        on_attach = function(client)
          client.server_capabilities.documentFormattingProvider = false
        end,
      })
    end)

    if not python_setup_ok then
      vim.notify("[lsp.servers.python] Setup failed: " .. tostring(err), vim.log.levels.WARN)
    end
  end, 100)
end

return M
