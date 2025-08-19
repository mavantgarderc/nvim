return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "lewis6991/gitsigns.nvim",
  },
  event = "VeryLazy",
  config = function()
    local core = require("plugins.lualine.core")
    local sections = require("plugins.lualine.sections")

    local lualine_opts = {
      options = core.options.get_options(),
      sections = sections.sections,
      inactive_sections = sections.inactive_sections,
      tabline = sections.tabline,
      winbar = sections.winbar,
      inactive_winbar = sections.inactive_winbar,
    }

    require("lualine").setup(lualine_opts)

    core.autocmds.setup(lualine_opts)
    core.keymaps.setup(lualine_opts)
  end,
}
