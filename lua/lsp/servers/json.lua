local M = {}

function M.setup(capabilities)
  local json_ok, lspconfig = pcall(require, "lspconfig")
  if not json_ok or not lspconfig then
    vim.notify("[lsp.servers.json] lspconfig not found", vim.log.levels.WARN)
    return
  end

  local json_ls_server = lspconfig.jsonls
  if not json_ls_server then
    vim.notify("[lsp.servers.json] jsonls not registered in lspconfig", vim.log.levels.WARN)
    return
  end

  json_ls_server.setup({
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
