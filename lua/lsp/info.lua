local M = {}

function M.show_server_info()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  if #clients == 0 then
    vim.notify("No LSP clients attached", vim.log.levels.INFO)
    return
  end

  local lines = { "# LSP Server Information\n" }
  for _, client in ipairs(clients) do
    table.insert(lines, string.format("## %s", client.name))
    table.insert(lines, string.format("- ID: %d", client.id))
    table.insert(lines, string.format("- Root: %s", client.config.root_dir or "N/A"))
    table.insert(lines, string.format("- Filetypes: %s", table.concat(client.config.filetypes or {}, ", ")))

    -- Capabilities
    table.insert(lines, "### Capabilities:")
    local caps = client.server_capabilities
    for key, value in pairs(caps) do
      if type(value) == "boolean" and value then
        table.insert(lines, string.format("- %s", key))
      end
    end
    table.insert(lines, "")
  end

  -- Create floating window
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(buf, "filetype", "markdown")

  local width = 80
  local height = 30
  ---@diagnostic disable-next-line: unused-local
  local _win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    col = (vim.o.columns - width) / 2,
    row = (vim.o.lines - height) / 2,
    style = "minimal",
    border = "rounded",
  })

  vim.keymap.set("n", "q", ":close<CR>", { buffer = buf, silent = true })
end

-- Add keymap
vim.keymap.set("n", "<leader>lI", function()
  require("lsp.info").show_server_info()
end, { desc = "LSP Server Info" })

return M
