local g       = vim.g
local fn      = vim.fn
local api     = vim.api
local opt_loc = vim.opt_local

return {
  {
    "tpope/vim-dadbod",
    lazy = true,
    cmd  = { "DB" },
  },

  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      {
        "tpope/vim-dadbod",
        lazy = true
      },
      {
        "kristijanhusak/vim-dadbod-completion",
        ft = { "sql", "mysql", "plsql", "sqlite", "postgresql", "psql" },
        lazy = true
      },
    },
    cmd = {
      "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer", "DBUIRenameBuffer", "DBUILastQueryInfo",
    },
    init = function()
      -- UI settings
      g.db_ui_use_nerd_fonts             = 1
      g.db_ui_show_database_icon         = 1
      g.db_ui_force_echo_notifications   = 1
      g.db_ui_win_position               = "left"
      g.db_ui_winwidth                   = 40
      g.db_ui_auto_execute_table_helpers = 1
      g.db_ui_execute_on_save            = 0
      g.db_ui_use_nvim_notify            = 1

      -- Saved-queries directory (create if missing)
      local save_dir                     = fn.stdpath("config") .. "/db_ui/saved_queries"
      if fn.isdirectory(save_dir) == 0 then fn.mkdir(save_dir, "p") end
      g.db_ui_save_location = save_dir

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

      g.db_ui_table_helpers = {
        mysql = {
          Count   = "select count(1) from \"{table}\"",
          Explain = "explain {last_query}",
        },
        sqlite = {
          Describe = "PRAGMA table_info(\"{table}\")",
        },
        postgresql = {
          Count    = "select count(1) from \"{table}\"",
          Explain  = "explain (analyze, buffers) {last_query}",
          Describe = "\\d+ \"{table}\"",
        },
        oracle = {
          Count    = "SELECT COUNT(1) FROM \"{table}\"",
          Describe = "DESC \"{table}\"",
          Explain  = "EXPLAIN PLAN FOR {last_query}",
        },
        plsql = {
          Count    = "SELECT COUNT(1) FROM \"{table}\"",
          Describe = "DESC \"{table}\"",
          Explain  = "EXPLAIN PLAN FOR {last_query}",
        },
      }

      g.db_ui_disable_mappings = 1
    end,
    config = function()
      require("core.keymaps.dadbod")

      api.nvim_create_autocmd("FileType", {
        pattern = { "sql", "mysql", "plsql", "sqlite", "postgresql", "psql" },
        callback = function()
          require("cmp").setup.buffer({
            sources = {
              { name = "vim-dadbod-completion" },
              { name = "buffer" },
              { name = "luasnip" },
            },
          })
        end,
      })

      api.nvim_create_autocmd("FileType", {
        pattern = { "sql", "mysql", "plsql", "sqlite", "postgresql", "psql" },
        callback = function()
          opt_loc.commentstring = "-- %s"
          opt_loc.expandtab     = true
          opt_loc.shiftwidth    = 2
          opt_loc.tabstop       = 2
          opt_loc.softtabstop   = 2
        end,
      })

      if pcall(require, "notify") then
        g.db_ui_use_nvim_notify = 1
      end
    end,
  },

  {
    "kristijanhusak/vim-dadbod-completion",
    ft     = { "sql", "mysql", "plsql", "sqlite", "postgresql", "psql" },
    lazy   = true,
    config = function()
      local ok, cmp = pcall(require, "cmp")
      if not ok then return end
      cmp.setup.filetype({ "sql", "mysql", "plsql", "sqlite", "postgresql", "psql" }, {
        sources = cmp.config.sources({
          { name = "vim-dadbod-completion" },
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },
}
