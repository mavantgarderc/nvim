return {
  "j-hui/fidget.nvim",
  event = "LspAttach",
  lazy = true,
  opts = {
    progress = {
      display = {
        render_limit = 16,
        done_ttl = 3,
        progress_ttl = math.huge,
      },
    },
    notification = {
      window = {
        normal_hl = "Comment",
        winblend = 0,
        border = "rounded",
        zindex = 45,
        max_width = 0,
        max_height = 0,
        x_padding = 1,
        y_padding = 0,
        align = "top",
        relative = "editor",
      },
    },
  },
}
