local M = {}

function M.setup(capabilities)
  local ok, lspconfig = pcall(require, "lspconfig")
  if not ok or not lspconfig then
    vim.notify("[lsp.servers.json] lspconfig not found", vim.log.levels.WARN)
    return
  end

  local server = lspconfig.jsonls
  if not server then
    vim.notify("[lsp.servers.json] jsonls not registered in lspconfig", vim.log.levels.WARN)
    return
  end

  server.setup({
    capabilities = capabilities,
    on_attach = function(client)
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end,
    settings = {
      json = {
        schemas = require("schemastore").json.schemas(),
        validate = { enable = true },
        inlayHints = {
          chainingHints = true,
          parameterHints = true,
        },
      },
    },
  })
end

return M
