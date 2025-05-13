return{
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      -- {"3rd/image.nvim", opts = {}},
    },
    config = function()
       vim.keymap.set('n', '<C-n>', ':Neotree filesystem reveal right<CR>', {})
    end
  },
  {
    "MunifTanjim/nui.nvim",
  },
}