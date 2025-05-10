local M = {}

-- `nvim-cmp` capabilities
local status_cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
M.capabilities = status_cmp_ok and cmp_nvim_lsp.default_capabilities() or vim.lsp.protocol.make_client_capabilities()

-- Shared `on_attach` logic
M.on_attach = function(client, bufnr)
  -- Example: disable formatting for tsserver
  if client.name == "tsserver" then
    client.server_capabilities.documentFormattingProvider = false
  end

  -- Load LSP keybindings
  require("config.lsp.keymaps").setup(bufnr)
end

return M