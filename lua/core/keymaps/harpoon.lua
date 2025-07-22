local M = {}
local map = vim.keymap.set

function M.setup()
  local harpoon = require("harpoon")

  map("n", "<leader>a", function() harpoon:list():add() end, { desc = "Harpoon: Add File" })

  map("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon: Toggle Menu" })

  map("n", "<C-h>", function() harpoon:list():select(1) end, { desc = "Harpoon: Nav 1" })
  map("n", "<C-t>", function() harpoon:list():select(2) end, { desc = "Harpoon: Nav 2" })
  map("n", "<C-n>", function() harpoon:list():select(3) end, { desc = "Harpoon: Nav 3" })
  map("n", "<C-s>", function() harpoon:list():select(4) end, { desc = "Harpoon: Nav 4" })
end

return M
