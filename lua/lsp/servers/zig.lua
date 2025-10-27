local M = {}

function M.setup(capabilities)
  local zig_ls_ok, lspconfig = pcall(require, "lspconfig")
  if not zig_ls_ok or not lspconfig then
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
        inlayHints = {
          chainingHints = true,
          parameterHints = true,
        },
      },
    },
  })
end

return M
