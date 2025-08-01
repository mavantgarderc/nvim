local map = vim.keymap.set
local api = vim.api
local buf = vim.lsp.buf
local diagnostic = vim.diagnostic
local g = vim.g
local fn = vim.fn
local notify = vim.notify
local inspect = vim.inspect
local b = vim.b
local bo = vim.bo
local lsp = vim.lsp
local log = vim.log
local defer_fn = vim.defer_fn
local uri_from_bufnr = vim.uri_from_bufnr
local tbl_extend = vim.tbl_extend

local M = {}

function M.setup_lsp_keymaps()
  api.nvim_create_autocmd("LspAttach", {
    desc = "LSP actions",
    callback = function(event)
      local opts = { buffer = event.buf, silent = true }

      map("n", "<leader>K", buf.hover, opts)
      map("n", "<leader>gd", buf.definition, opts)
      map("n", "<leader>gD", buf.declaration, opts)
      map("n", "<leader>gi", buf.implementation, opts)
      map("n", "<leader>go", buf.type_definition, opts)
      map("n", "<leader>gr", buf.references, opts)
      map("n", "<leader>gs", buf.signature_help, opts)

      map("n", "<leader>grn", buf.rename, opts)
      map("n", "<leader>ca", buf.code_action, opts)
      map("v", "<leader>ca", buf.code_action, opts)
      map({ "n", "x" }, "<leader>gra", buf.code_action, opts)

      map("n", "<leader>e", diagnostic.open_float, opts)
      map("n", "<leader>q", diagnostic.setloclist, opts)
      map("n", "<leader>[d", function() diagnostic.jump({ count = -1 }) end, opts)
      map("n", "<leader>]d", function() diagnostic.jump({ count = 1 }) end, opts)

      map("n", "<leader>[e", function() diagnostic.jump({ count = -1, severity = diagnostic.severity.ERROR }) end, opts)
      map("n", "<leader>]e", function() diagnostic.jump({ count = 1, severity = diagnostic.severity.ERROR }) end, opts)

      map("n", "<leader>wa", buf.add_workspace_folder, opts)
      map("n", "<leader>wr", buf.remove_workspace_folder, opts)
      map("n", "<leader>wl", function()
        print(inspect(buf.list_workspace_folders()))
      end, opts)

      local has_telescope, telescope = pcall(require, "telescope.builtin")
      if has_telescope then
        map("n", "<leader>li", telescope.lsp_implementations, { desc = "LSP implementations" })
        map("n", "<leader>lr", telescope.lsp_references, { desc = "LSP references" })
        map("n", "<leader>ld", telescope.lsp_definitions, { desc = "LSP definitions" })
        map("n", "<leader>lt", telescope.lsp_type_definitions, { desc = "LSP type definitions" })
        map("n", "<leader>ls", telescope.lsp_document_symbols, { desc = "Document symbols" })
        map("n", "<leader>le", telescope.diagnostics, { desc = "Diagnostics" })
        map("n", "<leader>lw", telescope.lsp_workspace_symbols, { desc = "Workspace symbols" })
      end

      -- toggle auto-lint
      b.lsp_format_on_save = false
      map("n", "<leader>tf", function()
        if b.lsp_format_on_save then
          b.lsp_format_on_save = false
          notify("LSP format on save disabled for buffer", log.levels.INFO)
        else
          b.lsp_format_on_save = true
          notify("LSP format on save enabled for buffer", log.levels.INFO)
        end
      end, opts)

      -- lint
      map("n", "<F3>", function()
        lsp.buf.format({
          async = false,
          filter = function(client)
            return client.name == "null-ls"
          end
        })
        lsp.buf.code_action({
          context = {
            only = { "source.organizeImports", "source.fixAll" },
            diagnostics = diagnostic.get(0),
          },
          apply = true,
        })
        notify("Manual formatting & linting triggered", log.levels.INFO)
      end, { desc = "Manual formatting & linting (F3)" })

      -- Get client information for language-specific keymaps
      local clients = lsp.get_clients({ bufnr = event.buf })
      local client_names = {}
      for _, client in ipairs(clients) do
        table.insert(client_names, client.name)
      end

      -- C# / OmniSharp specific keymaps
      local ft = bo[event.buf].filetype
      if ft == "cs" then
        local omnisharp_client = nil
        for _, client in ipairs(clients) do
          if client.name == "omnisharp" then
            omnisharp_client = client
            break
          end
        end

        if omnisharp_client then
          -- Helper function to check if OmniSharp is ready
          local function is_omnisharp_ready()
            return omnisharp_client.initialized or false
          end

          -- Add missing usings
          map("n", "<leader>cu", function()
            if is_omnisharp_ready() then
              lsp.buf.code_action({
                context = {
                  only = { "source.addMissingImports" },
                },
                apply = true,
              })
            else
              notify("OmniSharp still initializing, please wait...", log.levels.WARN)
            end
          end, tbl_extend("force", opts, { desc = "Add missing usings" }))

          -- Organize imports
          map("n", "<leader>co", function()
            if is_omnisharp_ready() then
              lsp.buf.code_action({
                context = {
                  only = { "source.organizeImports" },
                },
                apply = true
              })
            else
              notify("OmniSharp still initializing, please wait...", log.levels.WARN)
            end
          end, tbl_extend("force", opts, { desc = "Organize imports" }))

          -- Remove unnecessary usings
          map("n", "<leader>cr", function()
            if is_omnisharp_ready() then
              lsp.buf.code_action({
                context = {
                  only = { "source.removeUnnecessaryImports" },
                },
                apply = true,
              })
            else
              notify("OmniSharp still initializing, please wait...", log.levels.WARN)
            end
          end, tbl_extend("force", opts, { desc = "Remove unnecessary usings" }))

          -- Debug code actions
          map("n", "<leader>cd", function()
            if not is_omnisharp_ready() then
              notify("OmniSharp still initializing, please wait...", log.levels.WARN)
              return
            end

            local params = lsp.util.make_range_params()
            params.context = {
              diagnostics = diagnostic.get(event.buf, { lnum = fn.line('.') - 1 })
            }

            lsp.buf_request(event.buf, 'textDocument/codeAction', params, function(err, result, ctx, config)
              if err then
                notify("Error getting code actions: " .. err.message, log.levels.ERROR)
                return
              end

              if not result or #result == 0 then
                notify("No code actions available", log.levels.INFO)
                return
              end

              print("Available code actions:")
              for i, action in ipairs(result) do
                print(string.format("%d: %s (kind: %s)", i, action.title or "No title", action.kind or "No kind"))
              end
            end)
          end, tbl_extend("force", opts, { desc = "Debug code actions" }))

          -- Test running keymaps (if netcoredbg is available)
          if fn.executable("netcoredbg") == 1 then
            map("n", "<leader>rt", function()
              if is_omnisharp_ready() then
                lsp.buf.code_action({
                  context = {
                    only = { "source.runTest" },
                  },
                  apply = true,
                })
              else
                notify("OmniSharp still initializing, please wait...", log.levels.WARN)
              end
            end, tbl_extend("force", opts, { desc = "Run test" }))

            map("n", "<leader>dt", function()
              if is_omnisharp_ready() then
                lsp.buf.code_action({
                  context = {
                    only = { "source.debugTest" },
                  },
                  apply = true,
                })
              else
                notify("OmniSharp still initializing, please wait...", log.levels.WARN)
              end
            end, tbl_extend("force", opts, { desc = "Debug test" }))
          end
        end
      end
    end,
  })
end

return M
