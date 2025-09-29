return {
  "epwalsh/obsidian.nvim",
  version = "*",
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },

  opts = {
    workspaces = {
      {
        name = "vanaheim",
        path = vim.fn.expand("~/projects/0-shelfs/obsdn/Vanaheim"),
      },
    },
    notes_subdir = "z-Inbox",
    new_notes_location = "z-Inbox",
    ui = {
      enable = false,
    },

    mappings = {
      ["<leader>go"] = {
        action = function()
          return require("obsidian").util.gf_passthrough()
        end,
        opts = { noremap = false, expr = true, buffer = true },
      },
    },
  },

  config = function(_, opts)
    local obsidian = require("obsidian")
    local api = vim.api
    obsidian.setup(opts)

    local keymaps = require("core.keymaps.obsidian")

    api.nvim_create_autocmd("FileType", {
      pattern = "markdown",
      callback = function(args)
        keymaps.set_keymaps(args.buf)
      end,
    })
  end,
}
