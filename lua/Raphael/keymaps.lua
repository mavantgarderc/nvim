local M = {}

function M.setup(core)
  local leader = "<leader>t"

  vim.keymap.set("n", leader .. "p", function() core.pick() end, { desc = "Raphael picker" })
  vim.keymap.set("n", leader .. "n", function() vim.notify("Next theme TBD") end, { desc = "Next theme" })
  vim.keymap.set("n", leader .. "N", function() vim.notify("Previous theme TBD") end, { desc = "Previous theme" })
  vim.keymap.set("n", leader .. "r", function() vim.notify("Random theme TBD") end, { desc = "Random theme" })
end

return M
