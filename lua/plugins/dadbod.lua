-- lua/plugins/dadbod.lua
-- vim-dadbod plugin spec for lazy.nvim

return {
  {
    "tpope/vim-dadbod",
    lazy = true,
  },
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      "tpope/vim-dadbod",
      "kristijanhusak/vim-dadbod-completion",
    },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    init = function()
      -- Load database connections from .env before DBUI starts
      -- require("core.sql_env").setup()

      -- Set up keymaps early (they'll load plugins on demand)
      require("core.keymaps.dadbod").setup()

      -- DBUI settings
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_show_database_icon = 1
      vim.g.db_ui_force_echo_notifications = 1
      vim.g.db_ui_win_position = "left"
      vim.g.db_ui_winwidth = 40

      -- Save queries in config directory
      vim.g.db_ui_save_location = vim.fn.stdpath("config") .. "/db_ui"

      -- Auto-execute table helpers
      vim.g.db_ui_auto_execute_table_helpers = 1

      -- IMPORTANT: Execute queries in visual select in DBUI buffers
      vim.g.db_ui_execute_on_save = 0
    end,
    config = function()
      -- Global DadbodExecute function - SIMPLE AND WORKING
      _G.DadbodExecute = function(query, db_key)
        -- Validate database exists and URL is non-empty
        if not vim.g.dbs or not vim.g.dbs[db_key] or vim.g.dbs[db_key] == "" then
          local available = vim.g.dbs and table.concat(vim.tbl_keys(vim.g.dbs), ", ") or "none"
          vim.notify(
            string.format("Database '%s' not found or empty URL.\nAvailable: %s\nCheck .env and reload with :lua require('core.sql_env').reload()", db_key, available),
            vim.log.levels.ERROR
          )
          return
        end

        local db_url = vim.g.dbs[db_key]

        -- Create new buffer for query
        vim.cmd("botright 15split")
        local result_buf = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_win_set_buf(0, result_buf)

        -- Set buffer options
        vim.bo[result_buf].filetype = "dbout"
        vim.bo[result_buf].buftype = "nofile"
        vim.bo[result_buf].bufhidden = "wipe"

        -- Write query to buffer
        vim.api.nvim_buf_set_lines(result_buf, 0, -1, false, vim.split(query, "\n"))

        -- Execute using vim-dadbod's :DB command
        -- This is the CORRECT way to use dadbod
        vim.cmd(string.format("%%DB %s", vim.fn.shellescape(db_url)))

        vim.notify("Query executed on " .. db_key, vim.log.levels.INFO)
      end
    end,
  },
  {
    "kristijanhusak/vim-dadbod-completion",
    dependencies = "vim-dadbod",
    ft = { "sql", "mysql", "plsql", "sqlite", "postgresql", "psql" },
    init = function()
      -- Setup completion for SQL filetypes
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "sql", "mysql", "plsql", "sqlite", "postgresql", "psql" },
        callback = function()
          -- Check if cmp is available
          local ok, cmp = pcall(require, "cmp")
          if not ok then return end

          local sources = vim.tbl_deep_extend("force", cmp.get_config().sources or {}, {
            { name = "vim-dadbod-completion" },
          })
          cmp.setup.buffer({ sources = sources })
        end,
      })
    end,
  },
}
