return {
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-ui-select.nvim",
    },
    config = function()
      local telescope = require("telescope")
      local builtin = require("telescope.builtin")

      telescope.setup({
        extensions = {
          ["ui-select"] = require("telescope.themes").get_dropdown(),
        },
      })

      -- Load extension
      telescope.load_extension("ui-select")

      -- Keymaps
      vim.keymap.set("n", "<leader>pf", builtin.find_files, { desc = "[P]roject [F]iles" })
      vim.keymap.set("n", "<C-p>", builtin.git_files, { desc = "[G]it [F]iles" })
      vim.keymap.set("n", "<leader>ps", function()
        builtin.grep_string({ search = vim.fn.input("Grep > ") })
      end, { desc = "[P]roject [S]earch string" })

      -- Optional extra keymaps (uncomment to enable)
      -- vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
      -- vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
      -- vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
      -- vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]elect [S]ource" })
      -- vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
      -- vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
      -- vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
      -- vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
      -- vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = "[S]earch Recent Files" })
      -- vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })

      -- Current buffer fuzzy find (dropdown)
      -- vim.keymap.set("n", "<leader>/", function()
      --   builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
      --     winblend = 10,
      --     previewer = false,
      --   }))
      -- end, { desc = "[/] Search in buffer" })

      -- Live grep only in open files
      -- vim.keymap.set("n", "<leader>s/", function()
      --   builtin.live_grep({
      --     grep_open_files = true,
      --     prompt_title = "Live Grep in Open Files",
      --   })
      -- end, { desc = "[S]earch [/] in Open Files" })

      -- Search Neovim config files
      -- vim.keymap.set("n", "<leader>sn", function()
      --   builtin.find_files({ cwd = vim.fn.stdpath("config") })
      -- end, { desc = "[S]earch [N]eovim files" })
    end,
  },
}

