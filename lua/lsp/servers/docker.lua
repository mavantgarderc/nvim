local M = {}

function M.setup(capabilities)
  local docker_ok, lspconfig = pcall(require, "lspconfig")
  if not docker_ok or not lspconfig then
    vim.notify("[lsp.servers.docker] lspconfig not found", vim.log.levels.WARN)
    return
  end

  local docker_server = lspconfig.dockerls
  if not docker_server then
    vim.notify("[lsp.servers.docker] dockerls not registered in lspconfig", vim.log.levels.WARN)
    return
  end

  docker_server.setup({
    capabilities = capabilities,
    on_attach = function(client)
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end,
    settings = {
      docker = {
        languageserver = {
          diagnostics = { enable = true },
        },
        inlayHints = {
          chainingHints = true,
          parameterHints = true,
        },
      },
    },
  })
end

return M
