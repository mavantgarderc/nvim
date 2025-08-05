local g = vim.g
local fn = vim.fn
local api = vim.api
local opt_local = vim.opt_local

return {
  {
    "tpope/vim-dadbod",
    lazy = true,
    cmd = { "DB" },
  },

  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod",                     lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql", "psql" }, lazy = true },
    },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    init = function()
      g.db_ui_use_nerd_fonts = 1
      g.db_ui_show_database_icon = 1
      g.db_ui_force_echo_notifications = 1
      g.db_ui_win_position = "left"
      g.db_ui_winwidth = 40
      g.db_ui_auto_execute_table_helpers = 1

      g.db_ui_save_location = fn.stdpath("config") .. require("plenary.path").path.sep .. "db_ui"

      g.db_ui_execute_on_save = 0
      g.db_ui_use_nvim_notify = 1

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
          Count = "select count(1) from \"{table}\"",
          Explain = "explain {last_query}",
        },
        sqlite = {
          Describe = "PRAGMA table_info(\"{table}\")",
        },
        postgresql = {
          Count = "select count(1) from \"{table}\"",
          Explain = "explain (analyze, buffers) {last_query}",
          Describe = "\\d+ \"{table}\"",
        },
        oracle = {
          Count = "SELECT COUNT(1) FROM \"{table}\"",
          Describe = "DESC \"{table}\"",
          Explain = "EXPLAIN PLAN FOR {last_query}",
        },
        plsql = {
          Count = "SELECT COUNT(1) FROM \"{table}\"",
          Describe = "DESC \"{table}\"",
          Explain = "EXPLAIN PLAN FOR {last_query}",
        },
      }

      g.db_ui_disable_mappings = 1
    end,
    config = function()
      require("core.keymaps.dadbod")

      api.nvim_create_autocmd("FileType", {
        pattern = { "sql", "mysql", "plsql" },
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
        pattern = { "sql", "mysql", "plsql" },
        callback = function()
          opt_local.commentstring = "-- %s"
          opt_local.expandtab = true
          opt_local.shiftwidth = 2
          opt_local.tabstop = 2
          opt_local.softtabstop = 2
        end,
      })

      if pcall(require, "notify") then
        g.db_ui_use_nvim_notify = 1
      end
    end,
  },

  {
    "kristijanhusak/vim-dadbod-completion",
    ft = { "sql", "mysql", "plsql" },
    lazy = true,
    config = function()
      local cmp_ok, cmp = pcall(require, "cmp")
      if cmp_ok then
        cmp.setup.filetype({ "sql", "mysql", "plsql" }, {
          sources = cmp.config.sources({
            { name = "vim-dadbod-completion" },
            { name = "buffer" },
            { name = "path" },
          }),
        })
      end
    end,
  },
}
