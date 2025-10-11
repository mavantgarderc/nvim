local map = vim.keymap.set

return {
  "Vigemus/iron.nvim",
  config = function()
    local iron = require("iron.core")

    iron.setup({
      config = {
        scratch_repl = true,
        repl_definition = {
          sh = {
            command = { "zsh" },
          },
          python = {
            command = { "python3" }, -- or ipython
            format = require("iron.fts.common").bracketed_paste,
          },
        },
        repl_open_cmd = require("iron.view").bottom(40),
      },
      keymaps = {
        send_motion = "<leader>sc",
        visual_send = "<leader>sc",
        send_file = "<leader>sf",
        send_line = "<leader>sl",
        send_until_cursor = "<leader>su",
        send_mark = "<leader>sm",
        mark_motion = "<leader>mc",
        mark_visual = "<leader>mc",
        remove_mark = "<leader>md",
        cr = "<leader>s<CR>",
        interrupt = "<leader>s<leader>",
        exit = "<leader>sq",
        clear = "<leader>cl",
      },
      highlight = {
        italic = true,
      },
      ignore_blank_lines = true,
    })

    map("n", "<leader>rs", ":IronRepl<CR>")
    map("n", "<leader>rr", ":IronRestart<CR>")
    map("n", "<leader>rf", ":IronFocus<CR>")
    map("n", "<leader>rh", ":IronHide<CR>")
  end,
}
