local M = {}

local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

local g = vim.g
local notify = vim.notify
local ui = vim.ui
local cmd = vim.cmd
local tbl_keys = vim.tbl_keys
local log = vim.log
local api = vim.api
local tbl_extend = vim.tbl_extend
local fn = vim.fn
local lsp = vim.lsp
local b = vim.b
local bo = vim.bo

-- Database UI keymaps
function M.setup_ui_keymaps()
  map("n", "<leader>db", ":DBUI<CR>", { desc = "Open Database UI" })
  map("n", "<leader>dt", ":DBUIToggle<CR>", { desc = "Toggle Database UI" })
  map("n", "<leader>da", ":DBUIAddConnection<CR>", { desc = "Add DB Connection" })
  map("n", "<leader>df", ":DBUIFindBuffer<CR>", { desc = "Find DB Buffer" })
  map("n", "<leader>dr", ":DBUIRenameBuffer<CR>", { desc = "Rename DB Buffer" })
  map("n", "<leader>dl", ":DBUILastQueryInfo<CR>", { desc = "Last Query Info" })

  -- Quick connection shortcuts
  map("n", "<leader>dc", function()
    local connections = g.dbs or {}
    if #connections == 0 then
      notify("No database connections configured", log.levels.WARN)
      return
    end

    ui.select(
      tbl_keys(connections),
      { prompt = "Select database connection:" },
      function(choice)
        if choice then
          cmd("DB " .. choice)
        end
      end
    )
  end, { desc = "Quick Connect to DB" })
end

-- SQL execution keymaps
function M.setup_sql_keymaps()
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

-- DBUI buffer-specific keymaps
function M.setup_dbui_buffer_keymaps()
  local dbui_mappings = {
    ["<CR>"] = "<Plug>(DBUI_SelectLine)",
    ["o"] = "<Plug>(DBUI_SelectLine)",
    ["S"] = "<Plug>(DBUI_SelectLineVsplit)",
    ["R"] = "<Plug>(DBUI_Redraw)",
    ["d"] = "<Plug>(DBUI_DeleteLine)",
    ["A"] = "<Plug>(DBUI_AddConnection)",
    ["H"] = "<Plug>(DBUI_ToggleDetails)",
    ["r"] = "<Plug>(DBUI_RenameLine)",
    ["q"] = "<Plug>(DBUI_Quit)",
  }

  api.nvim_create_autocmd("FileType", {
    pattern = "dbui",
    callback = function(event)
      local opts = { buffer = event.buf, noremap = false, silent = true }
      for lhs, rhs in pairs(dbui_mappings) do
        vim.keymap.set("n", lhs, rhs, opts)
      end
    end,
  })
end

-- SQL buffer-specific keymaps
function M.setup_sql_buffer_keymaps()
  api.nvim_create_autocmd("FileType", {
    pattern = { "sql", "mysql", "plsql" },
    callback = function(event)
      local opts = { buffer = event.buf, noremap = true, silent = true }

      map("n", "<localleader>r", ":DB<CR>",  tbl_extend("force", opts, { desc = "Execute current line" }))
      map("v", "<localleader>r", ":DB<CR>",  tbl_extend("force", opts, { desc = "Execute selection" }))
      map("n", "<localleader>R", ":%DB<CR>", tbl_extend("force", opts, { desc = "Execute entire buffer" }))

      map("n", "<localleader>h", function()
        local word = fn.expand("<cword>")
        cmd("help " .. word)
      end, tbl_extend("force", opts, { desc = "Help for word under cursor" }))

      map("n", "<localleader>f", function()
        if fn.executable("sqlformat") == 1 then
          cmd("%!sqlformat --reindent --keywords upper --identifiers lower -")
        else
          notify("sqlformat not found. Install it with: pip install sqlparse", log.levels.WARN)
        end
      end, tbl_extend("force", opts, { desc = "Format SQL" }))

      -- Explain query
      map("n", "<localleader>e", function()
        local line = api.nvim_get_current_line()
        cmd("DB EXPLAIN " .. line)
      end, tbl_extend("force", opts, { desc = "Explain current query" }))

      -- Describe table
      map("n", "<localleader>d", function()
        local word = fn.expand("<cword>")
        cmd("DB DESCRIBE " .. word)
      end, tbl_extend("force", opts, { desc = "Describe table under cursor" }))
    end,
  })
end

function M.setup_lsp_integration()
  api.nvim_create_autocmd("LspAttach", {
    pattern = { "*.sql", "*.mysql", "*.plsql" },
    callback = function(event)
      local opts = { buffer = event.buf, noremap = true, silent = true }

      map("n", "gd", lsp.buf.definition, tbl_extend("force", opts, { desc = "Go to definition" }))
      map("n", "gr", lsp.buf.references, tbl_extend("force", opts, { desc = "Show references" }))
      map("n", "K", lsp.buf.hover, tbl_extend("force", opts, { desc = "Show hover info" }))
      map("n", "<leader>rn", lsp.buf.rename, tbl_extend("force", opts, { desc = "Rename symbol" }))
      map("n", "<leader>ca", lsp.buf.code_action, tbl_extend("force", opts, { desc = "Code actions" }))
      map("n", "<C-k>", lsp.buf.signature_help, tbl_extend("force", opts, { desc = "Signature help" }))
    end,
  })
end

function M.setup_utility_keymaps()
  -- Quick database switching
  map("n", "<leader>dw", function()
    local dbs = g.dbs or {}
    local db_names = tbl_keys(dbs)

    if #db_names == 0 then
      notify("No databases configured", log.levels.WARN)
      return
    end

    ui.select(db_names, {
      prompt = "Switch to database: ",
    }, function(choice)
      if choice then
        b.db = dbs[choice]
        notify("Switched to database: " .. choice, log.levels.INFO)
      end
    end)
  end, { desc = "Switch database for current buffer" })

  -- Show current database
  map("n", "<leader>di", function()
    local current_db = b.db or g.db or "No database set"
    notify("Current database: " .. current_db, log.levels.INFO)
  end, { desc = "Show current database" })

  -- Open SQL scratch buffer
  map("n", "<leader>ds", function()
    cmd("enew")
    bo.filetype = "sql"
    bo.buftype = "nofile"
    bo.bufhidden = "hide"
    bo.swapfile = false
  end, { desc = "Open SQL scratch buffer" })

  -- Save query with name
  map("n", "<leader>dq", function()
    ui.input({ prompt = "Query name: " }, function(name)
      if name and name ~= "" then
        local query_dir = fn.stdpath("config") .. "/db_ui/saved_queries"
        fn.mkdir(query_dir, "p")
        local filename = query_dir .. "/" .. name .. ".sql"
        cmd("write " .. filename)
        notify("Query saved as: " .. filename, log.levels.INFO)
      end
    end)
  end, { desc = "Save query with name" })
end

-- Initialize all keymaps
function M.setup()
  M.setup_ui_keymaps()
  M.setup_sql_keymaps()
  M.setup_dbui_buffer_keymaps()
  M.setup_sql_buffer_keymaps()
  M.setup_lsp_integration()
  M.setup_utility_keymaps()
end

-- Auto-setup when this module is required
M.setup()

return M
