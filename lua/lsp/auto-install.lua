local M = {}

-- Map LSP server names to Mason package names
local lsp_to_mason = {
  cssls = "css-lsp",
  html = "html-lsp",
  jsonls = "json-lsp",
  ts_ls = "typescript-language-server",
  yamlls = "yaml-language-server",
  bashls = "bash-language-server",
  vimls = "vim-language-server",
  lua_ls = "lua-language-server",
  pyright = "pyright",
  rust_analyzer = "rust-analyzer",
  gopls = "gopls",
  clangd = "clangd",
  marksman = "marksman",
  graphql = "graphql-language-service-cli",
}

function M.prompt_install_server(server_name)
  -- Convert LSP name to Mason package name
  local mason_package = lsp_to_mason[server_name] or server_name

  local choice = vim.fn.confirm(string.format("LSP server '%s' is not installed. Install it?", server_name), "&Yes\n&No", 1)

  if choice == 1 then
    vim.cmd("MasonInstall " .. mason_package)
    vim.notify("Installing " .. mason_package, vim.log.levels.INFO)
  end
end

-- Auto-detect and prompt for missing servers
function M.check_and_prompt()
  vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
      local ft = args.match
      local server_map = {
        python = "pyright",
        javascript = "ts_ls",
        typescript = "ts_ls",
        lua = "lua_ls",
        rust = "rust_analyzer",
        go = "gopls",
        c = "clangd",
        cpp = "clangd",
        html = "html",
        css = "cssls",
        json = "jsonls",
        yaml = "yamlls",
        markdown = "marksman",
        sh = "bashls",
        vim = "vimls",
        graphql = "graphql",
      }

      local server = server_map[ft]
      if server then
        -- Safely check if mason-registry is available
        local ok, mason_registry = pcall(require, "mason-registry")
        if ok then
          -- Convert LSP name to Mason package name for checking
          local mason_package = lsp_to_mason[server] or server

          -- Check if the package exists in registry first
          if mason_registry.has_package(mason_package) then
            if not mason_registry.is_installed(mason_package) then
              vim.defer_fn(function()
                M.prompt_install_server(server)
              end, 500)
            end
          end
        end
      end
    end,
  })
end

return M
