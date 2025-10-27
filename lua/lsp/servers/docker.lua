local M = {}

function M.setup(capabilities)
  local ok, lspconfig = pcall(require, "lspconfig")
  if not ok or not lspconfig then
    vim.notify("[lsp.servers.docker] lspconfig not found", vim.log.levels.WARN)
    return
  end

  local server = lspconfig.dockerls
  if not server then
    vim.notify("[lsp.servers.docker] dockerls not registered in lspconfig", vim.log.levels.WARN)
    return
  end

  server.setup({
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
