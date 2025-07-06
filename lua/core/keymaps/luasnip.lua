local map = vim.keymap.set
local ls = require("luasnip")

-- LuaSnip keymaps
map({"i"}, "<C-K>",
    function() ls.expand()
end, { silent = true, desc = "Expand snippet" })

map({"i", "s"}, "<C-L>",
    function() ls.jump( 1)
end, { silent = true, desc = "Jump to next snippet node" })

map({"i", "s"}, "<C-J>",
    function() ls.jump(-1)
end, { silent = true, desc = "Jump to previous snippet node" })

map({"i", "s"}, "<C-E>", function()
  if ls.choice_active() then
    ls.change_choice(1)
  end
end, { silent = true, desc = "Change snippet choice" })
