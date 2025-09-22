local M = {}
local fn = vim.fn

function M.setup(capabilities)
  vim.lsp.config("lua_ls", {
    capabilities = capabilities,
    on_attach = function(client, bufnr)
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
    end,
    settings = {
      Lua = {
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          library = {
            [fn.expand("$VIMRUNTIME/lua")] = true,
            [fn.stdpath("config") .. "/lua"] = true,
          },
          checkThirdParty = false,
        },
        telemetry = {
          enable = false,
        },
        completion = {
          callSnippet = "Replace",
        },
        format = {
          enable = false,
        },
      },
    },
  })
end

return M
