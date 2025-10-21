-- lua/core/keymaps/dadbod.lua
local M = {}

local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then options = vim.tbl_extend("force", options, opts) end
  vim.keymap.set(mode, lhs, rhs, options)
end

local function get_db()
  local url = vim.b.db or vim.g.db
  if url then return url end

  local conns = vim.g.dbs or {}
  if vim.tbl_isempty(conns) then
    vim.notify("No database connections configured", vim.log.levels.WARN)
    return nil
  end

  local choice = nil
  vim.ui.select(vim.tbl_keys(conns), { prompt = "Select database:" }, function(selected)
    choice = selected
  end)
  if not choice then return nil end

  return conns[choice]  -- Return the URL
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
      if choice then
        vim.g.db = conns[choice]  -- Set global db for quick connect
        vim.notify("Connected to: " .. choice, vim.log.levels.INFO)
      end
    end)
  end, { desc = "Quick Connect to DB" })
end

function M.setup_sql_keymaps()
  -- top-level quick execution commands, consistent across DBs
  map("n", "<leader>ss", function()
    local line = vim.api.nvim_get_current_line()
    if line == "" then
      vim.notify("Empty line - nothing to execute", vim.log.levels.WARN)
      return
    end
    local db = get_db()
    if not db then return end
    vim.cmd("." .. "DB " .. vim.fn.fnameescape(db))
  end, { desc = "Execute SQL line" })

  map("v", "<leader>ss", function()
    local start = vim.fn.getpos("'<")[2]
    local finish = vim.fn.getpos("'>")[2]
    local lines = vim.api.nvim_buf_get_lines(0, start - 1, finish, false)
    local query = table.concat(lines, "\n")
    if query == "" then
      vim.notify("Empty selection - nothing to execute", vim.log.levels.WARN)
      return
    end
    local db = get_db()
    if not db then return end
    vim.cmd("'<,'>" .. "DB " .. vim.fn.fnameescape(db))
  end, { desc = "Execute SQL selection" })

  map("n", "<leader>sf", function()
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local query = table.concat(lines, "\n")
    if query == "" then
      vim.notify("Empty buffer - nothing to execute", vim.log.levels.WARN)
      return
    end
    local db = get_db()
    if not db then return end
    vim.cmd("%" .. "DB " .. vim.fn.fnameescape(db))
  end, { desc = "Execute entire SQL file" })

  map("n", "<leader>sx", function()
    vim.cmd("w")
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local query = table.concat(lines, "\n")
    if query == "" then
      vim.notify("Empty buffer - nothing to execute", vim.log.levels.WARN)
      return
    end
    local db = get_db()
    if not db then return end
    vim.cmd("%" .. "DB " .. vim.fn.fnameescape(db))
  end, { desc = "Save and execute SQL file" })
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

      -- buffer-local leader mappings
      vim.keymap.set("n", "<localleader>r", function()
        local line = vim.api.nvim_get_current_line()
        if line == "" then
          vim.notify("Empty line - nothing to execute", vim.log.levels.WARN)
          return
        end
        local db = get_db()
        if not db then return end
        vim.cmd("." .. "DB " .. vim.fn.fnameescape(db))
      end, vim.tbl_extend("force", opts, { desc = "Execute current line" }))

      vim.keymap.set("v", "<localleader>r", function()
        local start = vim.fn.getpos("'<")[2]
        local finish = vim.fn.getpos("'>")[2]
        local lines = vim.api.nvim_buf_get_lines(0, start - 1, finish, false)
        local query = table.concat(lines, "\n")
        if query == "" then
          vim.notify("Empty selection - nothing to execute", vim.log.levels.WARN)
          return
        end
        local db = get_db()
        if not db then return end
        vim.cmd("'<,'>" .. "DB " .. vim.fn.fnameescape(db))
      end, vim.tbl_extend("force", opts, { desc = "Execute selection" }))

      vim.keymap.set("n", "<localleader>R", function()
        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        local query = table.concat(lines, "\n")
        if query == "" then
          vim.notify("Empty buffer - nothing to execute", vim.log.levels.WARN)
          return
        end
        local db = get_db()
        if not db then return end
        vim.cmd("%" .. "DB " .. vim.fn.fnameescape(db))
      end, vim.tbl_extend("force", opts, { desc = "Execute entire buffer" }))

      vim.keymap.set("n", "<localleader>h", function()
        local w = vim.fn.expand("<cword>")
        vim.cmd("help " .. w)
      end, vim.tbl_extend("force", opts, { desc = "Help for word under cursor" }))

      vim.keymap.set("n", "<localleader>f", function()
        if vim.fn.executable("sqlformat") == 1 then
          vim.cmd("%!sqlformat --reindent --keywords upper --identifiers lower -")
        else
          vim.notify("sqlformat not found. Install: pip install sqlparse", vim.log.levels.WARN)
        end
      end, vim.tbl_extend("force", opts, { desc = "Format SQL" }))

      vim.keymap.set("n", "<localleader>e", function()
        local line = vim.api.nvim_get_current_line()
        if line == "" then
          vim.notify("Empty line - nothing to explain", vim.log.levels.WARN)
          return
        end
        local db = get_db()
        if not db then return end
        -- Assuming SQLite; adjust for other DBs if needed
        vim.api.nvim_buf_set_lines(buf, vim.fn.line('.') - 1, vim.fn.line('.'), false, {"EXPLAIN QUERY PLAN " .. line})
        vim.cmd("." .. "DB " .. vim.fn.fnameescape(db))
        -- Restore original line after execution if desired
      end, vim.tbl_extend("force", opts, { desc = "Explain current query (SQLite-specific)" }))

      vim.keymap.set("n", "<localleader>d", function()
        local tbl = vim.fn.expand("<cword>")
        if tbl == "" then
          vim.notify("No table name under cursor", vim.log.levels.WARN)
          return
        end
        local db = get_db()
        if not db then return end
        -- Assuming SQLite; adjust for other DBs if needed
        vim.cmd("DB " .. vim.fn.fnameescape(db) .. " PRAGMA table_info('" .. tbl .. "');")
      end, vim.tbl_extend("force", opts, { desc = "Describe table under cursor (SQLite-specific)" }))
    end,
  })
end

function M.setup_lsp_integration()
  vim.api.nvim_create_autocmd("LspAttach", {
    pattern = { "*.sql", "*.mysql", "*.plsql", "*.sqlite", "*.postgresql", "*.psql" },
    callback = function(event)
      local bufnr = event.buf
      local o = { buffer = bufnr, noremap = true, silent = true }
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", o, { desc = "Go to definition" }))
      vim.keymap.set("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", o, { desc = "Show references" }))
      vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", o, { desc = "Show hover info" }))
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", o, { desc = "Rename symbol" }))
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", o, { desc = "Code actions" }))
      vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, vim.tbl_extend("force", o, { desc = "Signature help" }))
    end,
  })
end

function M.setup_utility_keymaps()
  map("n", "<leader>dw", function()
    local conns = vim.g.dbs or {}
    local names = vim.tbl_keys(conns)
    if vim.tbl_isempty(names) then
      vim.notify("No databases configured in vim.g.dbs. Check your .env file.", vim.log.levels.WARN)
      return
    end
    vim.ui.select(names, { prompt = "Switch to database:" }, function(choice)
      if choice and conns[choice] then
        vim.b.db = conns[choice]
        vim.notify("Switched to database: " .. choice, vim.log.levels.INFO)
      end
    end)
  end, { desc = "Switch database for current buffer" })

  map("n", "<leader>di", function()
    local buf_db = vim.b.db
    local global_db = vim.g.db
    local available = vim.g.dbs and vim.tbl_keys(vim.g.dbs) or {}

    local msg = "Database Info:\n"
    msg = msg .. "• Buffer DB: " .. (buf_db or "not set") .. "\n"
    msg = msg .. "• Global DB: " .. (global_db or "not set") .. "\n"
    msg = msg .. "• Available: " .. table.concat(available, ", ")

    vim.notify(msg, vim.log.levels.INFO)
  end, { desc = "Show current database" })

  map("n", "<leader>ds", function()
    vim.cmd("enew")
    vim.bo.filetype = "sql"
    vim.bo.buftype = "nofile"
    vim.bo.bufhidden = "hide"
    vim.bo.swapfile = false
    vim.notify("SQL scratch buffer created", vim.log.levels.INFO)
  end, { desc = "Open SQL scratch buffer" })

  map("n", "<leader>dq", function()
    vim.ui.input({ prompt = "Query name: " }, function(name)
      if name and name ~= "" then
        local dir = vim.fn.stdpath("config") .. "/db_ui/saved_queries"
        if vim.fn.isdirectory(dir) == 0 then
          vim.fn.mkdir(dir, "p")
        end
        local path = dir .. "/" .. name .. ".sql"
        vim.cmd("write " .. path)
        vim.notify("Query saved as: " .. path, vim.log.levels.INFO)
      end
    end)
  end, { desc = "Save query with name" })

  -- Debug keymap to check database connections
  map("n", "<leader>dD", function()
    local dbs = vim.g.dbs or {}
    if vim.tbl_isempty(dbs) then
      vim.notify("No databases loaded! Check:\n1. .env file in cwd or ~/.config/nvim/.env\n2. Has DB_UI_* entries\n3. vim-dotenv is installed", vim.log.levels.ERROR)
    else
      local msg = "Loaded databases:\n"
      for name, url in pairs(dbs) do
        -- Hide password in URL for security
        local safe_url = url:gsub("://([^:]+):([^@]+)@", "://%1:****@")
        msg = msg .. "• " .. name .. ": " .. safe_url .. "\n"
      end
      vim.notify(msg, vim.log.levels.INFO)
    end
  end, { desc = "Debug: Show all database connections" })

  -- TEST COMMAND - Execute a simple query to test everything works
  map("n", "<leader>dT", function()
    if not vim.g.dbs or vim.tbl_isempty(vim.g.dbs) then
      vim.notify("No databases configured. Press <leader>dD to debug.", vim.log.levels.ERROR)
      return
    end

    -- Get first available database URL
    local first_name = next(vim.g.dbs)
    local first_db = vim.g.dbs[first_name]
    if not first_db then
      vim.notify("No databases found", vim.log.levels.ERROR)
      return
    end

    vim.notify("Testing with database: " .. first_name, vim.log.levels.INFO)

    -- Test with SELECT 1
    vim.cmd("DB " .. vim.fn.fnameescape(first_db) .. " SELECT 1 as test;")
  end, { desc = "TEST: Execute simple query" })
end

function M.setup()
  M.setup_ui_keymaps()
  M.setup_sql_keymaps()
  M.setup_dbui_buffer_keymaps()
  M.setup_sql_buffer_keymaps()
  M.setup_lsp_integration()
  M.setup_utility_keymaps()
end

return M
