-- lua/core/keymaps/dadbod.lua
-- All dadbod-related keymaps extracted here.
-- Exports setup(map, with_db) where:
--  - map(mode, lhs, rhs, opts) is your mapping helper (noremap=true, silent=true)
--  - with_db(callback) is your async-safe DB selector

local M = {}

function M.setup(map, with_db)
  if type(map) ~= "function" or type(with_db) ~= "function" then
    vim.notify("dadbod keymaps: invalid arguments to setup(map, with_db)", vim.log.levels.ERROR)
    return
  end

  -------------------------------------------------------------------------
  -- DBUI Window keymaps (global)
  -------------------------------------------------------------------------
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
        vim.g.db = conns[choice]
        vim.notify("Connected to: " .. choice, vim.log.levels.INFO)
      end
    end)
  end, { desc = "Quick Connect to DB" })

  -------------------------------------------------------------------------
  -- Top-level SQL Execution keymaps (global)
  -------------------------------------------------------------------------
  map("n", "<leader>ss", function()
    local line = vim.api.nvim_get_current_line()
    if line == "" then
      vim.notify("Empty line - nothing to execute", vim.log.levels.WARN)
      return
    end
    with_db(function(db)
      vim.cmd("." .. "DB " .. vim.fn.fnameescape(db))
    end)
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
    with_db(function(db)
      vim.cmd("'<,'>" .. "DB " .. vim.fn.fnameescape(db))
    end)
  end, { desc = "Execute SQL selection" })

  map("n", "<leader>sf", function()
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local query = table.concat(lines, "\n")
    if query == "" then
      vim.notify("Empty buffer - nothing to execute", vim.log.levels.WARN)
      return
    end
    with_db(function(db)
      vim.cmd("%" .. "DB " .. vim.fn.fnameescape(db))
    end)
  end, { desc = "Execute entire SQL file" })

  map("n", "<leader>sx", function()
    vim.cmd("w")
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local query = table.concat(lines, "\n")
    if query == "" then
      vim.notify("Empty buffer - nothing to execute", vim.log.levels.WARN)
      return
    end
    with_db(function(db)
      vim.cmd("%" .. "DB " .. vim.fn.fnameescape(db))
    end)
  end, { desc = "Save and execute SQL file" })

  -------------------------------------------------------------------------
  -- DBUI buffer keymaps (filetype=dbui) - use plugin <Plug> mappings (noremap=false)
  -------------------------------------------------------------------------
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

  -------------------------------------------------------------------------
  -- SQL buffer-local mappings (localleader), and other buffer-specific helpers
  -------------------------------------------------------------------------
  vim.api.nvim_create_autocmd("FileType", {
    pattern = { "sql", "mysql", "plsql", "sqlite", "postgresql", "psql" },
    callback = function(event)
      local buf = event.buf
      local opts = { buffer = buf, noremap = true, silent = true }

      -- <localleader>r (normal): Execute current line
      vim.keymap.set("n", "<localleader>r", function()
        local line = vim.api.nvim_get_current_line()
        if line == "" then
          vim.notify("Empty line - nothing to execute", vim.log.levels.WARN)
          return
        end
        with_db(function(db)
          vim.cmd("." .. "DB " .. vim.fn.fnameescape(db))
        end)
      end, vim.tbl_extend("force", opts, { desc = "Execute current line" }))

      -- <localleader>r (visual): Execute selection
      vim.keymap.set("v", "<localleader>r", function()
        local start = vim.fn.getpos("'<")[2]
        local finish = vim.fn.getpos("'>")[2]
        local lines = vim.api.nvim_buf_get_lines(0, start - 1, finish, false)
        local query = table.concat(lines, "\n")
        if query == "" then
          vim.notify("Empty selection - nothing to execute", vim.log.levels.WARN)
          return
        end
        with_db(function(db)
          vim.cmd("'<,'>" .. "DB " .. vim.fn.fnameescape(db))
        end)
      end, vim.tbl_extend("force", opts, { desc = "Execute selection" }))

      -- <localleader>R: Execute entire buffer
      vim.keymap.set("n", "<localleader>R", function()
        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        local query = table.concat(lines, "\n")
        if query == "" then
          vim.notify("Empty buffer - nothing to execute", vim.log.levels.WARN)
          return
        end
        with_db(function(db)
          vim.cmd("%" .. "DB " .. vim.fn.fnameescape(db))
        end)
      end, vim.tbl_extend("force", opts, { desc = "Execute entire buffer" }))

      -- <localleader>h: Help for word under cursor
      vim.keymap.set("n", "<localleader>h", function()
        local w = vim.fn.expand("<cword>")
        if w == "" then
          vim.notify("No word under cursor", vim.log.levels.WARN)
          return
        end
        vim.cmd("help " .. w)
      end, vim.tbl_extend("force", opts, { desc = "Help for word under cursor" }))

      -- <localleader>f: Format SQL (prefer sqlfluff, fallback to sqlformat)
      vim.keymap.set("n", "<localleader>f", function()
        if vim.fn.executable("sqlfluff") == 1 then
          -- Prefer sqlfluff (user has it via pipx)
          local ok, _ = pcall(vim.cmd, "%!sqlfluff fix --stdin")
          if not ok then
            -- fallback to sqlformat if sqlfluff invocation fails
            if vim.fn.executable("sqlformat") == 1 then
              vim.cmd("%!sqlformat --reindent --keywords upper --identifiers lower -")
            else
              vim.notify("sqlfluff failed and sqlformat not found. Install sqlfluff/sqlformat.", vim.log.levels.WARN)
            end
          end
        elseif vim.fn.executable("sqlformat") == 1 then
          vim.cmd("%!sqlformat --reindent --keywords upper --identifiers lower -")
        else
          vim.notify("sqlfluff/sqlformat not found. Install sqlfluff (pipx) or sqlformat (pip install sqlparse).",
            vim.log.levels.WARN)
        end
      end, vim.tbl_extend("force", opts, { desc = "Format SQL" }))

      -- <localleader>e: Explain current query (SQLite-specific)
      vim.keymap.set("n", "<localleader>e", function()
        local line = vim.api.nvim_get_current_line()
        if line == "" then
          vim.notify("Empty line - nothing to explain", vim.log.levels.WARN)
          return
        end
        -- Insert EXPLAIN QUERY PLAN <line> at the current line and execute it
        local cur = vim.fn.line(".")
        vim.api.nvim_buf_set_lines(buf, cur - 1, cur, false, { "EXPLAIN QUERY PLAN " .. line })
        with_db(function(db)
          vim.cmd("." .. "DB " .. vim.fn.fnameescape(db))
        end)
        -- Note: this replaces the current line with the EXPLAIN. Restore logic can be added if desired.
      end, vim.tbl_extend("force", opts, { desc = "Explain current query (SQLite-specific)" }))
    end,
  })

  -------------------------------------------------------------------------
  -- Utility / Test keymaps (global)
  -------------------------------------------------------------------------
  map("n", "<leader>dT", function()
    with_db(function(db)
      vim.notify("Testing DB connection...", vim.log.levels.INFO)
      vim.cmd("DB " .. vim.fn.fnameescape(db) .. " SELECT 1 as test;")
    end)
  end, { desc = "TEST: Execute simple query" })
end

return M
