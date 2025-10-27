local M = {}

function M.setup(capabilities)
  local rust_ok, lspconfig = pcall(require, "lspconfig")
  if not rust_ok or not lspconfig then
    vim.notify("[lsp.servers.rust] lspconfig not found", vim.log.levels.WARN)
    return
  end

  local server = lspconfig.rust_analyzer
  if not server then
    vim.notify("[lsp.servers.rust] rust_analyzer not registered in lspconfig", vim.log.levels.WARN)
    return
  end

  server.setup({
    capabilities = capabilities,
    on_attach = function(client)
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end,
    settings = {
      ["rust-analyzer"] = {
        cargo = { allFeatures = true },
        checkOnSave = { command = "clippy" },
        diagnostics = { disabled = { "unresolved-proc-macro" } },
        completion = { autoimport = { enable = true } },
        inlayHints = {
          chainingHints = true,
          parameterHints = true,
        },
      },
    },
  })
end

return M
