local M = {}
local fn = vim.fn

function M.setup(capabilities)
  local lspconfig = require("lspconfig")
  lspconfig.lua_ls.setup({
    capabilities = capabilities,
    -- Disable LSP formatting since we'll use StyLua
    on_attach = function(client, bufnr)
      -- Disable lua_ls formatting capabilities
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
