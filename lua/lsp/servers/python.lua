local lsp = vim.lsp

local M = {}

function M.setup(capabilities)
  lsp.config["pyright"] = {
    capabilities = capabilities,
    settings = {
      python = {
        analysis = {
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
          diagnosticMode = "workspace",
        },
      },
    },
  }
end

return M
