local M = {}

local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then options = vim.tbl_extend("force", options, opts) end
  vim.keymap.set(mode, lhs, rhs, options)
end

function M.setup_ui_keymaps()
  map("n", "<leader>dt", ":DBUIToggle<CR>", { desc = "Toggle Database UI" })
  map("n", "<leader>da", ":DBUIAddConnection<CR>", { desc = "Add DB Connection" })
  map("n", "<leader>df", ":DBUIFindBuffer<CR>", { desc = "Find DB Buffer" })
  map("n", "<leader>dr", ":DBUIRenameBuffer<CR>", { desc = "Rename DB Buffer" })
  map("n", "<leader>dl", ":DBUILastQueryInfo<CR>", { desc = "Last Query Info" })

  map("n", "<leader>dc", function()
    local conns = vim.g.dbs or {}
    if vim.tbl_isempty(conns) then
      vim.notify("No database connections configured", vim.log.levels.WARN)
      return
    end
    vim.ui.select(vim.tbl_keys(conns), { prompt = "Select database connection:" }, function(choice)
      if choice then vim.cmd("DB " .. choice) end
    end)
  end, { desc = "Quick Connect to DB" })

  map("n", "<leader>dm", function()
    vim.cmd("DB DB_DEV_MYSQL") -- replace with your default DB key from .env
    vim.notify("Connected to DB_DEV_MYSQL", vim.log.levels.INFO)
  end, { desc = "Connect to default MySQL DB" })
end

function M.setup_sql_keymaps()
  map("n", "<leader>ss", ":DB<CR>", { desc = "Execute SQL line" })
  map("v", "<leader>ss", ":DB<CR>", { desc = "Execute SQL selection" })
  map("n", "<leader>sf", ":%DB<CR>", { desc = "Execute entire SQL file" })

  map("n", "<leader>se", function()
    local line = vim.api.nvim_get_current_line()
    vim.cmd("DB " .. line)
  end, { desc = "Execute current line with DB" })

  map("n", "<leader>sx", function()
    vim.cmd("w")
    vim.cmd("%DB")
  end, { desc = "Save and execute SQL file" })

  map("v", "<leader>se", function()
    vim.cmd("'<,'>DB")
  end, { desc = "Execute visual selection" })
end

function M.setup_dbui_buffer_keymaps()
  local dbui = {
    ["<CR>"] = "<Plug>(DBUI_SelectLine)",
    ["o"] = "<Plug>(DBUI_SelectLine)",
    ["S"] = "<Plug>(DBUI_SelectLineVsplit)",
    ["R"] = "<Plug>(DBUI_Redraw)",
    ["d"] = "<Plug>(DBUI_DeleteLine)",
    ["A"] = "<Plug>(DBUI_AddConnection)",
    ["H"] = "<Plug>(DBUI_ToggleDetails)",
    ["r"] = "<Plug>(DBUI_RenameLine)",
    ["q"] = "<Plug>(DBUI_Quit)",
    ["<C-p>"] = "<Plug>(DBUI_GotoPreviousQuery)",
    ["<C-n>"] = "<Plug>(DBUI_GotoNextQuery)",
  }

  vim.api.nvim_create_autocmd("FileType", {
    pattern = "dbui",
    callback = function(event)
      for lhs, rhs in pairs(dbui) do
        vim.keymap.set("n", lhs, rhs, { buffer = event.buf, noremap = false, silent = true })
      end
    end,
  })
end

function M.setup_sql_buffer_keymaps()
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "sql", "mysql", "plsql", "sqlite", "postgresql", "psql" },
    callback = function(event)
      local buf = event.buf
      local opts = { buffer = buf, noremap = true, silent = true }

      map("n", "<localleader>r", ":DB<CR>", vim.tbl_extend("force", opts, { desc = "Execute current line" }))
      map("v", "<localleader>r", ":DB<CR>", vim.tbl_extend("force", opts, { desc = "Execute selection" }))
      map("n", "<localleader>R", ":%DB<CR>", vim.tbl_extend("force", opts, { desc = "Execute entire buffer" }))
      map("n", "<localleader>h", function()
        local w = vim.fn.expand("<cword>")
        vim.cmd("help " .. w)
      end, vim.tbl_extend("force", opts, { desc = "Help for word under cursor" }))

      map("n", "<localleader>f", function()
        if vim.fn.executable("sqlformat") == 1 then
          vim.cmd("%!sqlformat --reindent --keywords upper --identifiers lower -")
        else
          vim.notify("sqlformat not found. Install: pip install sqlparse", vim.log.levels.WARN)
        end
      end, vim.tbl_extend("force", opts, { desc = "Format SQL" }))

      map("n", "<localleader>e", function()
        local line = vim.api.nvim_get_current_line()
        vim.cmd("DB EXPLAIN " .. line)
      end, vim.tbl_extend("force", opts, { desc = "Explain current query" }))

      map("n", "<localleader>d", function()
        local tbl = vim.fn.expand("<cword>")
        vim.cmd("DB DESCRIBE " .. tbl)
      end, vim.tbl_extend("force", opts, { desc = "Describe table under cursor" }))
    end,
  })
end

function M.setup_lsp_integration()
  vim.api.nvim_create_autocmd("LspAttach", {
    pattern = { "*.sql", "*.mysql", "*.plsql", "*.sqlite", "*.postgresql", "*.psql" },
    callback = function(event)
      local bufnr = event.buf
      local o = { buffer = bufnr, noremap = true, silent = true }
      map("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", o, { desc = "Go to definition" }))
      map("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", o, { desc = "Show references" }))
      map("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", o, { desc = "Show hover info" }))
      map("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", o, { desc = "Rename symbol" }))
      map("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", o, { desc = "Code actions" }))
      map("n", "<C-k>", vim.lsp.buf.signature_help, vim.tbl_extend("force", o, { desc = "Signature help" }))
    end,
  })
end

function M.setup_utility_keymaps()
  map("n", "<leader>dw", function()
    local conns = vim.g.dbs or {}
    local names = vim.tbl_keys(conns)
    if vim.tbl_isempty(names) then
      vim.notify("No databases configured", vim.log.levels.WARN)
      return
    end
    vim.ui.select(names, { prompt = "Switch to database:" }, function(choice)
      if choice then
        vim.b.db = conns[choice]
        vim.notify("Switched to database: " .. choice, vim.log.levels.INFO)
      end
    end)
  end, { desc = "Switch database for current buffer" })

  map("n", "<leader>di", function()
    local cur = vim.b.db or vim.g.db or "No database set"
    vim.notify("Current database: " .. cur, vim.log.levels.INFO)
  end, { desc = "Show current database" })

  map("n", "<leader>ds", function()
    vim.cmd("enew")
    vim.bo.filetype = "sql"
    vim.bo.buftype = "nofile"
    vim.bo.bufhidden = "hide"
    vim.bo.swapfile = false
  end, { desc = "Open SQL scratch buffer" })

  map("n", "<leader>dq", function()
    vim.ui.input({ prompt = "Query name: " }, function(name)
      if name and name ~= "" then
        local dir = vim.fn.stdpath("config") .. "/db_ui/saved_queries"
        if vim.fn.isdirectory(dir) == 0 then vim.fn.mkdir(dir, "p") end
        local path = dir .. "/" .. name .. ".sql"
        vim.cmd("write " .. path)
        vim.notify("Query saved as: " .. path, vim.log.levels.INFO)
      end
    end)
  end, { desc = "Save query with name" })
end

function M.setup()
  M.setup_ui_keymaps()
  M.setup_sql_keymaps()
  M.setup_dbui_buffer_keymaps()
  M.setup_sql_buffer_keymaps()
  M.setup_lsp_integration()
  M.setup_utility_keymaps()
end

M.setup()

return M
