local M = {}

function M.setup(capabilities)
  local ok, lspconfig = pcall(require, "lspconfig")
  if not ok or not lspconfig then
    vim.notify("[lsp.servers.zig] lspconfig not found", vim.log.levels.WARN)
    return
  end

  local server = lspconfig.zls
  if not server then
    vim.notify("[lsp.servers.zig] zls not registered in lspconfig", vim.log.levels.WARN)
    return
  end

  server.setup({
    capabilities = capabilities,
    on_attach = function(client)
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end,
    settings = {
      zls = {
        enable_snippets = true,
        enable_autofix = true,
        warn_style = true,
      },
    },
  })
end

return M
