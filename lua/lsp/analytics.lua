local M = {}

function M.prompt_install_server(server_name)
  local choice = vim.fn.confirm(string.format("LSP server '%s' is not installed. Install it?", server_name), "&Yes\n&No", 1)

  if choice == 1 then
    vim.cmd("MasonInstall " .. server_name)
    vim.notify("Installing " .. server_name, vim.log.levels.INFO)
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
          -- Check if the package exists in registry first
          if mason_registry.has_package(server) then
            if not mason_registry.is_installed(server) then
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
