local lspconfig = require("lspconfig")
local mason_lspconfig = require("mason-lspconfig")

local servers = {
  "lua_ls",
  "tsserver",
  "html",
  "cssls",
  "jsonls",
  "bashls",
  "pyright",
}

mason_lspconfig.setup({
  ensure_installed = servers,
})

mason_lspconfig.setup_handlers({
  function(server_name)
    lspconfig[server_name].setup({
      on_attach = require("config.lsp.handlers").on_attach,
      capabilities = require("config.lsp.handlers").capabilities,
    })
  end,
})