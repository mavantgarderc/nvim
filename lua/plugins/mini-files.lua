return {
  "echasnovski/mini.nvim",
  version = false,
  lazy = true,
  keys = {
    { "-", "<cmd>lua require('mini.files').open(vim.fn.getcwd(), true)<CR>", desc = "Open mini.files (Directory)" },
  },
  config = function()
    local minifiles = require("mini.files")

    local function custom_sort(entries)
      local dotdirs = {}
      local dirs = {}
      local files = {}
      local dotfiles = {}

      -- Categorize entries
      for _, entry in ipairs(entries) do
        local name = entry.name
        local is_dir = entry.fs_type == "directory"
        local is_dot = name:sub(1, 1) == "." and name ~= ".."  -- Exclude parent '..'

        if is_dir and is_dot then
          table.insert(dotdirs, entry)
        elseif is_dir then
          table.insert(dirs, entry)
        elseif not is_dot then
          table.insert(files, entry)
        else
          table.insert(dotfiles, entry)
        end
      end

      -- Alphabetical sort helper (case-insensitive)
      local function alpha_sort(a, b)
        return string.lower(a.name) < string.lower(b.name)
      end

      -- Sort each category
      table.sort(dotdirs, alpha_sort)
      table.sort(dirs, alpha_sort)
      table.sort(files, alpha_sort)
      table.sort(dotfiles, alpha_sort)

      -- Concatenate in desired order
      local sorted = {}
      vim.list_extend(sorted, dotdirs)
      vim.list_extend(sorted, dirs)
      vim.list_extend(sorted, files)
      vim.list_extend(sorted, dotfiles)

      return sorted
    end

    minifiles.setup({
      content = {
        filter = nil,
        sort = custom_sort,
      },

      mappings = {
        close       = "q",
        go_in       = "l",
        go_in_plus  = "L",
        go_out      = "h",
        go_out_plus = "H",
        reset       = "<BS>",
        reveal_cwd  = "@",
        show_help   = "?",
        synchronize = "<leader>oo",
        trim_left   = "<<",
        trim_right  = ">>",
        delete      = "dd",
        new_file    = "ff",
        new_dir     = "FF",
      },

      options = {
        use_as_default_explorer = true,
        permanent_delete = false,
      },

      windows = {
        preview = false,
        width_focus = 50,
        width_nofocus = 15,
        width_preview = 25,
        max_number = math.huge,
      },
    })

    vim.keymap.set("n", "-", function()
      minifiles.open(vim.uv.cwd())
    end, { desc = "Open mini.files" })

    vim.keymap.set("n", "<leader>pv", function()
      minifiles.open(vim.uv.cwd())
    end, { desc = "Open mini.files" })

  end,
}
