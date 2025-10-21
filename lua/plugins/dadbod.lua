-- lua/plugins/dadbod.lua
local g = vim.g

-- Load dotenv helper (the new module)
local ok, sql_env = pcall(require, "core.sql_env")
if not ok then
  vim.notify("core.sql_env not found; skipping DB load", vim.log.levels.WARN)
else
  vim.g.dbs = sql_env.load_dotenv()
end

-- Basic validation
local function validate_dbs()
  local conns = vim.g.dbs or {}
  if vim.tbl_isempty(conns) then
    vim.notify("No database connections loaded from .env", vim.log.levels.WARN)
    return
  end
  for name, url in pairs(conns) do
    if not url:match("^%w+://") and not url:match("^sqlite:") then
      vim.notify("Invalid connection string for " .. name, vim.log.levels.ERROR)
    end
  end
end

vim.api.nvim_create_autocmd("VimEnter", {
  callback = validate_dbs,
  desc = "Validate database connections on startup",
})

-- Plugin specs (for lazy.nvim)
return {
  {
    "tpope/vim-dadbod",
    lazy = true,
    cmd = { "DB", "DBUI" },
  },

  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod",                     lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql", "sqlite", "postgresql", "psql" }, lazy = true },
    },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
      "DBUIRenameBuffer",
      "DBUILastQueryInfo",
    },
    init = function()
      -- UI settings: bottom split, 30% height
      g.db_ui_use_nerd_fonts = 1
      g.db_ui_show_database_icon = 1
      g.db_ui_force_echo_notifications = 1
      g.db_ui_win_position = "bottom"
      g.db_ui_winheight = 30 -- percent
      g.db_ui_auto_execute_table_helpers = 1
      g.db_ui_execute_on_save = 0
      g.db_ui_use_nvim_notify = 1

      -- Saved-queries directory
      local save_dir = vim.fn.stdpath("config") .. "/db_ui/saved_queries"
      if vim.fn.isdirectory(save_dir) == 0 then vim.fn.mkdir(save_dir, "p") end
      g.db_ui_save_location = save_dir

      -- Icons (kept from your config)
      g.db_ui_icons = {
        expanded = {
          db = " ",
          buffers = " ",
          saved_queries = " 󰰛",
          schemas = " 󱎤",
          schema = " 󰰡",
          tables = " ",
          table = " ",
        },
        collapsed = {
          db = " ",
          buffers = " ",
          saved_queries = " 󰰛",
          schemas = " 󱎤",
          schema = " 󰰡",
          tables = " ",
          table = " ",
        },
        saved_query = "",
        new_query = "",
        tables = "",
        buffers = "",
        add_connection = "",
        connection_ok = "",
        connection_error = "",
      }

      -- Table helpers for supported databases
      g.db_ui_table_helpers = {
        mysql = {
          Count = 'select count(1) from "{table}"',
          Explain = "explain {last_query}",
        },
        sqlite = {
          Describe = 'PRAGMA table_info("{table}")',
        },
        postgresql = {
          Count = 'select count(1) from "{table}"',
          Explain = "explain (analyze, buffers) {last_query}",
          Describe = '\\d+ "{table}"',
        },
        oracle = {
          Count = 'SELECT COUNT(1) FROM "{table}"',
          Describe = 'DESC "{table}"',
          Explain = "EXPLAIN PLAN FOR {last_query}",
        },
        plsql = {
          Count = 'SELECT COUNT(1) FROM "{table}"',
          Describe = 'DESC "{table}"',
          Explain = "EXPLAIN PLAN FOR {last_query}",
        },
        mssql = {
          Count = 'SELECT COUNT(1) FROM [{table}]',
          Describe = "EXEC sp_help '{table}'",
        },
      }

      g.db_ui_disable_mappings = 1
    end,
    config = function()
      -- load your keymaps module (assuming core.keymaps.dadbod exists)
      pcall(require, "core.keymaps.dadbod")

      -- Autocompletion buffer setup
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "sql", "mysql", "plsql", "sqlite", "postgresql", "psql" },
        callback = function()
          if pcall(require, "cmp") then
            require("cmp").setup.buffer({
              sources = {
                { name = "vim-dadbod-completion", priority = 1000 },
                { name = "luasnip",               priority = 750 },
                { name = "buffer",                priority = 500, keyword_length = 3 },
              },
            })
          end
        end,
      })

      -- SQL buffer style
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "sql", "mysql", "plsql", "sqlite", "postgresql", "psql" },
        callback = function()
          vim.opt_local.commentstring = "-- %s"
          vim.opt_local.expandtab = true
          vim.opt_local.shiftwidth = 2
          vim.opt_local.tabstop = 2
          vim.opt_local.softtabstop = 2
        end,
      })

      if pcall(require, "notify") then g.db_ui_use_nvim_notify = 1 end

      -- ========== Helpers: async execution, history, destructive-check ==========
      local function is_destructive(sql)
        if not sql then return false end
        local s = sql:upper()
        -- simple destructive check
        if s:match("^%s*DELETE") or s:match("^%s*UPDATE") or s:match("^%s*DROP") or s:match("^%s*ALTER")
            or s:match("^%s*TRUNCATE") then
          return true
        end
        return false
      end

      local function log_query(sql, db_key)
        local dir = vim.g.sql_log_dir or (vim.fn.stdpath("state") .. "/sql_logs")
        if vim.fn.isdirectory(dir) == 0 then vim.fn.mkdir(dir, "p") end
        local logfile = dir .. "/query_history.log"
        local f = io.open(logfile, "a")
        if f then
          local ts = os.date("%Y-%m-%d %H:%M:%S")
          f:write(string.format("[%s] [%s] %s\n", ts, db_key or "unknown", sql))
          f:close()
        end
      end

      -- Async wrapper to run DB commands through dadbod
      local function run_db_async(db_key, sql)
        sql = sql or ""
        if is_destructive(sql) then
          local ok = vim.fn.input("Destructive SQL detected. Type 'YES' to proceed: ")
          if ok ~= "YES" then
            vim.notify("Execution cancelled", vim.log.levels.INFO)
            return
          end
        end
        log_query(sql, db_key)

        -- use vim.fn.jobstart to keep it async. We call the DB via dadbod's :DB command
        -- Construct a temporary file to run DB command in background buffer
        local tmp = vim.fn.tempname() .. ".sql"
        local f = io.open(tmp, "w")
        if f then
          f:write(sql)
          f:close()
        end

        -- open results in bottom split, 30% height. We'll create a new buffer to show output.
        local out_buf = vim.api.nvim_create_buf(false, true)
        local win_height = math.max(6, math.floor(vim.o.lines * 0.30))
        vim.api.nvim_open_win(out_buf, true, {
          relative = "editor",
          width = vim.o.columns,
          height = win_height,
          row = vim.o.lines - win_height,
          col = 0,
          style = "minimal",
          border = "single",
        })
        vim.api.nvim_buf_set_option(out_buf, "filetype", "dbui")
        vim.api.nvim_buf_set_option(out_buf, "bufhidden", "wipe")

        -- Fire the DB command: use :DB <connection> < <tmpfile> and capture output via jobstart
        local cmd = table.concat({ "sh", "-c", string.format("nvim --headless +':silent DB %s < %s' +qa", db_key, tmp) },
          " ")
        -- We will fallback to synchronous DB if headless nvim not available; but attempt jobstart
        local job = vim.fn.jobstart(cmd, {
          stdout_buffered = true,
          stderr_buffered = true,
          on_stdout = function(_, data)
            if data then vim.api.nvim_buf_set_lines(out_buf, -1, -1, false, data) end
          end,
          on_stderr = function(_, data)
            if data then vim.api.nvim_buf_set_lines(out_buf, -1, -1, false, data) end
          end,
          on_exit = function()
            vim.api.nvim_buf_set_lines(out_buf, -1, -1, false, { "--- Finished ---" })
          end,
        })

        if job <= 0 then
          -- fallback: synchronous DB command executed in current nvim and put results in buffer
          vim.api.nvim_buf_set_lines(out_buf, 0, -1, false, {
            "Async execution failed, fallback to sync. Running in current nvim..."
          })
          vim.cmd("silent w! " .. tmp)
          vim.cmd("silent DB " .. db_key .. " < " .. tmp)
        end
      end

      -- Expose function for keymaps and manual use
      _G.DadbodExecute = function(query, db_key)
        db_key = db_key or "DB_DEV_POSTGRES"
        run_db_async(db_key, query)
      end

      -- ER Diagram generator (Graphviz-based)
      _G.DadbodERDiagram = function(db_key)
        db_key = db_key or "DB_DEV_POSTGRES"
        local tmpdot = vim.fn.tempname() .. ".dot"
        local outpng = vim.fn.tempname() .. ".png"
        -- Query to fetch table & relations (Postgres-first)
        local q = [[
SELECT
  tc.table_name, kcu.column_name, ccu.table_name AS foreign_table_name, ccu.column_name AS foreign_column_name
FROM
  information_schema.table_constraints AS tc
  JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
  JOIN information_schema.constraint_column_usage AS ccu
    ON ccu.constraint_name = tc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY'
ORDER BY tc.table_name;
]]
        -- For simplicity, we run DB DESCRIBE of all tables and then build a dot graph minimally.
        -- We'll call nvim headless again to run the SQL and capture output to a file.
        local tmpq = vim.fn.tempname() .. ".sql"
        local fh = io.open(tmpq, "w")
        if not fh then
          vim.notify("Failed to create temp file for ER diagram", vim.log.levels.ERROR)
          return
        end
        fh:write(q)
        fh:close()

        local cmd = string.format("nvim --headless +':silent DB %s < %s' +qa > %s 2>&1", db_key, tmpq, tmpdot .. ".raw")
        local j = vim.fn.system(cmd)
        -- Parse raw output (best-effort) into edges
        local raw = vim.fn.readfile(tmpdot .. ".raw")
        local edges = {}
        for _, line in ipairs(raw) do
          -- crude parse: lines containing '|' often show table | column -> foreign_table | foreign_column
          local t1, c1, ft, fc = line:match("(%w+)%s+|%s+(%w+)%s+->%s+(%w+)%s+|%s+(%w+)")
          if t1 and ft then
            table.insert(edges, { t1 = t1, ft = ft })
          else
            -- try to parse simple space-separated output
            local a, b, c, d = line:match("(%w+)%s+(%w+)%s+(%w+)%s+(%w+)")
            if a and c then table.insert(edges, { t1 = a, ft = c }) end
          end
        end

        -- Build DOT
        local dot = { "digraph ER {", "  graph [overlap=false];", "  node [shape=record];" }
        local seen = {}
        for _, e in ipairs(edges) do
          if not seen[e.t1] then
            table.insert(dot, string.format('  "%s" [label="%s"];', e.t1, e.t1))
            seen[e.t1] = true
          end
          if not seen[e.ft] then
            table.insert(dot, string.format('  "%s" [label="%s"];', e.ft, e.ft))
            seen[e.ft] = true
          end
          table.insert(dot, string.format('  "%s" -> "%s";', e.t1, e.ft))
        end
        table.insert(dot, "}")

        -- write .dot and run dot to make png
        local f = io.open(tmpdot, "w")
        if f then
          f:write(table.concat(dot, "\n"))
          f:close()
          -- run graphviz
          local r = vim.fn.system(string.format("dot -Tpng %s -o %s", tmpdot, outpng))
          if vim.v.shell_error == 0 then
            vim.notify("ER diagram generated: " .. outpng, vim.log.levels.INFO)
            -- open the image with system default viewer
            if vim.fn.executable("xdg-open") == 1 then
              vim.fn.jobstart({ "xdg-open", outpng }, { detach = true })
            end
          else
            vim.notify("Graphviz 'dot' failed. Install graphviz to generate ER diagrams.", vim.log.levels.ERROR)
          end
        else
          vim.notify("Failed to write dot file for ER diagram", vim.log.levels.ERROR)
        end
      end

      -- Add commands for quick usage
      vim.api.nvim_create_user_command("DBExec", function(opts)
        local db = opts.args:match("^%S+")
        local sql = string.sub(opts.args, #db + 2)
        _G.DadbodExecute(sql, db)
      end, { nargs = "+", complete = function() return vim.tbl_keys(vim.g.dbs or {}) end })

      vim.api.nvim_create_user_command("ERDiagram", function(opts)
        local db = opts.args ~= "" and opts.args or "DB_DEV_POSTGRES"
        _G.DadbodERDiagram(db)
      end, { nargs = "?", complete = function() return vim.tbl_keys(vim.g.dbs or {}) end })
    end,
  },
}
