return {
  "benlubas/molten-nvim",
  version = "*",
  build = ":UpdateRemotePlugins",
  ft = { "python", "markdown" },
  init = function()
    vim.g.molten_image_provider = "none" -- Ghostty does not support inline images
  end,
  config = function()
    require("molten").setup({})
  end,
}
