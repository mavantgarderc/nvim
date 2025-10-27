local M = {}

function M.setup(capabilities)
  vim.schedule(function()
    local ok, lspconfig = pcall(require, "lspconfig")
    if not ok then
      vim.notify("[lsp.servers.lua_ls] nvim-lspconfig not found", vim.log.levels.WARN)
      return
    end

    local configs_ok, configs = pcall(require, "lspconfig.configs")
    if not configs_ok then
      vim.notify("[lsp.servers.lua_ls] lspconfig.configs missing", vim.log.levels.WARN)
      return
    end

    if not configs.lua_ls then
      configs.lua_ls = {
        default_config = {
          cmd = { "lua-language-server" },
          filetypes = { "lua" },
          root_dir = lspconfig.util.root_pattern(
            ".git",
            ".luarc.json",
            ".luarc.jsonc",
            ".luacheckrc",
            ".stylua.toml",
            "selene.toml"
          ),
          settings = {},
        },
      }
    end

    lspconfig.lua_ls.setup({
      capabilities = capabilities,
      on_attach = function(client)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
      end,
      settings = {
        Lua = {
          diagnostics = { globals = { "vim" } },
          workspace = {
            library = {
              [vim.fn.expand("$VIMRUNTIME/lua")] = true,
              [vim.fn.stdpath("config") .. "/lua"] = true,
            },
            checkThirdParty = false,
          },
          telemetry = { enable = false },
          completion = { callSnippet = "Replace" },
          format = { enable = false },
          inlayHints = {
            chainingHints = true,
            parameterHints = true,
          },
        },
      },
    })
  end)
end

return M
