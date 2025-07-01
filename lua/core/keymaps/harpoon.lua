local M = {}

function M.setup()
    local harpoon = require("harpoon")
    local map = vim.keymap.set

    map("n", "<leader>a", function() harpoon:list():add() end, { desc = "Harpoon: Add File" })

    map("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon: Toggle Menu" })

    map("n", "<C-1>", function() harpoon:list():select(1) end, { desc = "Harpoon: Nav 1" })
    map("n", "<C-2>", function() harpoon:list():select(2) end, { desc = "Harpoon: Nav 2" })
    map("n", "<C-3>", function() harpoon:list():select(3) end, { desc = "Harpoon: Nav 3" })
    map("n", "<C-4>", function() harpoon:list():select(4) end, { desc = "Harpoon: Nav 4" })
end

return M
