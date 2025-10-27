return {
  "stevearc/oil.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "nvim-lua/plenary.nvim",
  },

  config = function()
    local oil = require("oil")
    local fn = vim.fn
    local api = vim.api
    local cmd = vim.cmd
    local bo = vim.bo

    api.nvim_create_user_command("OilCheatsheet", function()
      local lines = {
        "##### Oil.nvim Keymap Cheatsheet #####",
        "--------------------------------------",
        " <CR>     → Open file/directory",
        " <C-s>    → Open in vertical split",
        " <C-x>    → Open in horizontal split",
        " <C-t>    → Open in new tab",
        " <C-p>    → Preview file",
        " <C-c>    → Close Oil buffer",
        " <C-l>    → Refresh",
        " '-'      → Go to parent directory",
        " '_'      → Open cwd",
        " '`'      → cd to dir",
        " '~'      → tcd to dir (tab)",
        " gs       → Change sort",
        " gx       → Open with system app",
        " g.       → Toggle dotfiles",
        " g\\      → Toggle trash mode",
        " gh       → Toggle dotfiles (alt)",
        " gp       → Reopen Oil at current path",
        " q        → Close Oil",
        "",
        " <leader>e     → Toggle sidebar",
        " <leader>nf    → New file in Oil",
        " <leader>nd    → New directory in Oil",
        " <leader>pv    → Open Oil file explorer",
      }

      cmd("new")
      api.nvim_buf_set_lines(0, 0, -1, false, lines)
      bo.buftype = "nofile"
      bo.bufhidden = "wipe"
      bo.swapfile = false
      bo.readonly = true
      bo.filetype = "oilcheatsheet"
      cmd("normal! gg")
    end, { desc = "Open Oil Keymap Cheatsheet" })

    ---@diagnostic disable-next-line: redundant-parameter
    oil.setup({
      default_file_explorer = true,
      show_hidden = true,

      columns = {
        "icon",
        -- "permissions",
        -- "size",
        -- "mtime",
      },

      sort = {
        { "type", "asc" },
        { "name", "asc" },
      },

      buf_options = {
        buflisted = false,
        bufhidden = "hide",
      },

      win_options = {
        wrap = false,
        signcolumn = "yes",
        cursorline = true,
        foldcolumn = "0",
        spell = false,
        list = false,
        conceallevel = 0,
        concealcursor = "",
        winblend = fn.has("nvim-0.10") == 1 and 10 or nil,
      },

      delete_to_trash = true,
      skip_confirm_for_simple_edits = true,
      prompt_save_on_select_new_entry = true,
      cleanup_delay_ms = 2000,

      lsp_file_methods = {
        timeout_ms = 1000,
        autosave_changes = false,
      },

      constrain_cursor = "editable",
      watch_for_changes = fn.has("nvim-0.10") == 1,

      keymaps = {
        ["g?"] = "actions.show_help",
        ["<CR>"] = "actions.select",
        ["<C-s>"] = { "actions.select", opts = { vertical = true } },
        ["<C-x>"] = { "actions.select", opts = { horizontal = true } },
        ["<C-t>"] = { "actions.select", opts = { tab = true } },
        ["<C-p>"] = "actions.preview",
        ["<C-c>"] = "actions.close",
        ["<C-l>"] = "actions.refresh",
        ["-"] = "actions.parent",
        ["_"] = "actions.open_cwd",
        ["`"] = "actions.cd",
        ["~"] = { "actions.cd", opts = { scope = "tab" } },
        ["gs"] = "actions.change_sort",
        ["gx"] = "actions.open_external",
        ["g."] = "actions.toggle_hidden",
        ["g\\"] = "actions.toggle_trash",
        ["gh"] = "actions.toggle_hidden",
        ["q"] = "actions.close",
        ["gp"] = function()
          oil.open(fn.expand("%:p:h"))
        end,
      },

      use_default_keymaps = true,

      view_options = {
        show_hidden = true,
        is_hidden_file = function(name, _)
          return name:sub(1, 1) == "."
        end,
        is_always_hidden = function()
          return false
        end,
        natural_order = false,
        sort = {
          { "type", "asc" },
          { "name", "asc" },
        },
      },

      float = {
        padding = 2,
        border = "rounded",
        preview_split = "auto",
        win_options = fn.has("nvim-0.10") == 1 and { winblend = 10 } or {},
        override = function(conf)
          return conf
        end,
      },

      preview = {
        border = "rounded",
        win_options = fn.has("nvim-0.10") == 1 and { winblend = 10 } or {},
      },

      progress = {
        border = "rounded",
        win_options = fn.has("nvim-0.10") == 1 and { winblend = 10 } or {},
      },

      ssh = {
        border = "rounded",
      },
    })

    api.nvim_create_autocmd("VimEnter", {
      callback = function()
        local arg = fn.argv(0)
        if arg ~= "" and fn.isdirectory(arg) == 1 then
          oil.open()
        end
      end,
    })

    ---@diagnostic disable-next-line: different-requires
    require("core.keymaps.oil").setup()
  end,
}
