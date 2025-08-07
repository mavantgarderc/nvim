local M = {}

local g   = vim.g
local fn  = vim.fn
local api = vim.api
local ui  = vim.ui
local cmd = vim.cmd
local log = vim.log
local b   = vim.b
local bo  = vim.bo
local tbl_extend = vim.tbl_extend
local tbl_isempty = vim.tbl_isempty
local notify = vim.notify
local tbl_keys = vim.tbl_keys
local lsp = vim.lsp

local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then options = tbl_extend("force", options, opts) end
  vim.keymap.set(mode, lhs, rhs, options)
end

function M.setup_ui_keymaps()
  -- map("n", "<leader>db", ":DBUI<CR>", { desc = "Open Database UI" })
  map("n", "<leader>dt", ":DBUIToggle<CR>", { desc = "Toggle Database UI" })
  map("n", "<leader>da", ":DBUIAddConnection<CR>", { desc = "Add DB Connection" })
  map("n", "<leader>df", ":DBUIFindBuffer<CR>", { desc = "Find DB Buffer" })
  map("n", "<leader>dr", ":DBUIRenameBuffer<CR>", { desc = "Rename DB Buffer" })
  map("n", "<leader>dl", ":DBUILastQueryInfo<CR>", { desc = "Last Query Info" })

  map("n", "<leader>dc", function()
    local conns = g.dbs or {}
    if tbl_isempty(conns) then
      notify("No database connections configured", log.levels.WARN)
      return
    end
    ui.select(tbl_keys(conns), { prompt = "Select database connection:" }, function(choice)
      if choice then cmd("DB " .. choice) end
    end)
  end, { desc = "Quick Connect to DB" })
end

function M.setup_sql_keymaps()
  -- Execute
  map("n", "<leader>ss", ":DB<CR>", { desc = "Execute SQL line" })
  map("v", "<leader>ss", ":DB<CR>", { desc = "Execute SQL selection" })
  map("n", "<leader>sf", ":%DB<CR>", { desc = "Execute entire SQL file" })

  map("n", "<leader>se", function()
    local line = api.nvim_get_current_line()
    cmd("DB " .. line)
  end, { desc = "Execute current line with DB" })

  map("n", "<leader>sx", function()
    cmd("w")
    cmd("%DB")
  end, { desc = "Save and execute SQL file" })

  map("v", "<leader>se", function()
    cmd("'<,'>DB")
  end, { desc = "Execute visual selection" })
end

function M.setup_dbui_buffer_keymaps()
  local dbui = {
    ["<CR>"] = "<Plug>(DBUI_SelectLine)",
    ["o"]    = "<Plug>(DBUI_SelectLine)",
    ["S"]    = "<Plug>(DBUI_SelectLineVsplit)",
    ["R"]    = "<Plug>(DBUI_Redraw)",
    ["d"]    = "<Plug>(DBUI_DeleteLine)",
    ["A"]    = "<Plug>(DBUI_AddConnection)",
    ["H"]    = "<Plug>(DBUI_ToggleDetails)",
    ["r"]    = "<Plug>(DBUI_RenameLine)",
    ["q"]    = "<Plug>(DBUI_Quit)",
  }

  api.nvim_create_autocmd("FileType", {
    pattern = "dbui",
    callback = function(event)
      for lhs, rhs in pairs(dbui) do
        vim.keymap.set("n", lhs, rhs, { buffer = event.buf, noremap = false, silent = true })
      end
    end,
  })
end

function M.setup_sql_buffer_keymaps()
  api.nvim_create_autocmd("FileType", {
    pattern = { "sql", "mysql", "plsql", "sqlite", "postgresql", "psql" },
    callback = function(event)
      local buf = event.buf
      local opts = { buffer = buf, noremap = true, silent = true }

      map("n", "<localleader>r", ":DB<CR>", vim.tbl_extend("force", opts, { desc = "Execute current line" }))
      map("v", "<localleader>r", ":DB<CR>", vim.tbl_extend("force", opts, { desc = "Execute selection" }))
      map("n", "<localleader>R", ":%DB<CR>", vim.tbl_extend("force", opts, { desc = "Execute entire buffer" }))
      map("n", "<localleader>h", function() -- help on word
        local w = fn.expand("<cword>")
        cmd("help " .. w)
      end, tbl_extend("force", opts, { desc = "Help for word under cursor" }))

      map("n", "<localleader>f", function() -- format SQL
        if fn.executable("sqlformat") == 1 then
          cmd("%!sqlformat --reindent --keywords upper --identifiers lower -")
        else
          notify("sqlformat not found. Install: pip install sqlparse", log.levels.WARN)
        end
      end, tbl_extend("force", opts, { desc = "Format SQL" }))

      map("n", "<localleader>e", function() -- explain
        local line = api.nvim_get_current_line()
        cmd("DB EXPLAIN " .. line)
      end, tbl_extend("force", opts, { desc = "Explain current query" }))

      map("n", "<localleader>d", function() -- describe table
        local tbl = fn.expand("<cword>")
        cmd("DB DESCRIBE " .. tbl)
      end, tbl_extend("force", opts, { desc = "Describe table under cursor" }))
    end,
  })
end

function M.setup_lsp_integration()
  api.nvim_create_autocmd("LspAttach", {
    pattern = { "*.sql", "*.mysql", "*.plsql", "*.sqlite", "*.postgresql", "*.psql" },
    callback = function(event)
      local bufnr = event.buf
      local o = { buffer = bufnr, noremap = true, silent = true }
      map("n", "gd", lsp.buf.definition, tbl_extend("force", o, { desc = "Go to definition" }))
      map("n", "gr", lsp.buf.references, tbl_extend("force", o, { desc = "Show references" }))
      map("n", "K",  lsp.buf.hover, tbl_extend("force", o, { desc = "Show hover info" }))
      map("n", "<leader>rn", lsp.buf.rename, tbl_extend("force", o, { desc = "Rename symbol" }))
      map("n", "<leader>ca", lsp.buf.code_action, tbl_extend("force", o, { desc = "Code actions" }))
      map("n", "<C-k>", lsp.buf.signature_help, tbl_extend("force", o, { desc = "Signature help" }))
    end,
  })
end

function M.setup_utility_keymaps()
  map("n", "<leader>dw", function() -- switch buffer DB
    local conns = g.dbs or {}
    local names = tbl_keys(conns)
    if tbl_isempty(names) then
      notify("No databases configured", log.levels.WARN)
      return
    end
    ui.select(names, { prompt = "Switch to database:" }, function(choice)
      if choice then
        b.db = conns[choice]
        notify("Switched to database: " .. choice, log.levels.INFO)
      end
    end)
  end, { desc = "Switch database for current buffer" })

  map("n", "<leader>di", function() -- show current DB
    local cur = b.db or g.db or "No database set"
    notify("Current database: " .. cur, log.levels.INFO)
  end, { desc = "Show current database" })

  map("n", "<leader>ds", function() -- scratch buffer
    cmd("enew")
    bo.filetype  = "sql"
    bo.buftype   = "nofile"
    bo.bufhidden = "hide"
    bo.swapfile  = false
  end, { desc = "Open SQL scratch buffer" })

  map("n", "<leader>dq", function() -- save query
    ui.input({ prompt = "Query name: " }, function(name)
      if name and name ~= "" then
        local dir = fn.stdpath("config") .. "/db_ui/saved_queries"
        if fn.isdirectory(dir) == 0 then fn.mkdir(dir, "p") end
        local path = dir .. "/" .. name .. ".sql"
        cmd("write " .. path)
        notify("Query saved as: " .. path, log.levels.INFO)
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
