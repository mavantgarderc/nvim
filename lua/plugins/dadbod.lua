local g = vim.g

-- Load .env file for database connections
local dotenv = require("core.dotenv")
local env_file = vim.fn.stdpath("config") .. "/.env"
vim.g.dbs = dotenv.load_dotenv(env_file)

-- Validate database connections
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

return {
  {
    "tpope/vim-dadbod",
    lazy = true,
    cmd = { "DB" },
    dependencies = { "core.dotenv" },
  },

  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod",                     lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql", "sqlite", "postgresql", "psql" }, lazy = true },
      { "core.dotenv" },
    },
    cmd = {
      "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer", "DBUIRenameBuffer", "DBUILastQueryInfo",
    },
    init = function()
      -- UI settings
      g.db_ui_use_nerd_fonts = 1
      g.db_ui_show_database_icon = 1
      g.db_ui_force_echo_notifications = 1
      g.db_ui_win_position = "left"
      g.db_ui_winwidth = 40
      g.db_ui_auto_execute_table_helpers = 1
      g.db_ui_execute_on_save = 0
      g.db_ui_use_nvim_notify = 1

      -- Saved-queries directory
      local save_dir = vim.fn.stdpath("config") .. "/db_ui/saved_queries"
      if vim.fn.isdirectory(save_dir) == 0 then vim.fn.mkdir(save_dir, "p") end
      g.db_ui_save_location = save_dir

      -- Custom icons
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

      -- Autocompletion for SQL filetypes
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "sql", "mysql", "plsql", "sqlite", "postgresql", "psql" },
        callback = function()
          require("cmp").setup.buffer({
            sources = {
              { name = "vim-dadbod-completion", priority = 1000 },
              { name = "luasnip",               priority = 750 },
              { name = "buffer",                priority = 500, keyword_length = 3 },
            },
          })
        end,
      })

      -- SQL buffer settings
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

      -- Enable nvim-notify if available
      if pcall(require, "notify") then
        g.db_ui_use_nvim_notify = 1
      end
    end,
  },
}
