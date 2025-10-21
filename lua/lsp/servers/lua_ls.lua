local M = {}

function M.setup(capabilities)
  local ok, lspconfig = pcall(require, "lspconfig")
  if not ok or not lspconfig then
    vim.notify("[lsp.servers.lua_ls] lspconfig not found", vim.log.levels.WARN)
    return
  end

  local server = lspconfig.lua_ls or lspconfig.sumneko_lua
  if not server then
    vim.notify(
      "[lsp.servers.lua_ls] neither 'lua_ls' nor 'sumneko_lua' is available in lspconfig. Ensure nvim-lspconfig is installed and the server is registered (mason / manual).",
      vim.log.levels.WARN
    )
    return
  end

  server.setup({
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
            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
            [vim.fn.stdpath("config") .. "/lua"] = true,
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
