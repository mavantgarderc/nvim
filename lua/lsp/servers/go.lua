local M = {}

function M.setup(capabilities)
  local ok, lspconfig = pcall(require, "lspconfig")
  if not ok or not lspconfig then
    vim.notify("[lsp.servers.go] lspconfig not found", vim.log.levels.WARN)
    return
  end

  local server = lspconfig.gopls
  if not server then
    vim.notify("[lsp.servers.go] gopls not registered in lspconfig", vim.log.levels.WARN)
    return
  end

  server.setup({
    capabilities = capabilities,
    on_attach = function(client)
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end,
    settings = {
      gopls = {
        analyses = {
          unusedparams = true,
          nilness = true,
          shadow = true,
        },
        staticcheck = true,
        gofumpt = false,
      },
    },
  })
end

return M
