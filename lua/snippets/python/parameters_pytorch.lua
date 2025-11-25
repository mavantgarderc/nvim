local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s({
    trig = "ptpar",
    name = "PyTorch Parameters Section",
    desc = "Inserts a Parameters section in PyTorch style.",
  }, {
    t({ "", "Parameters", "----------" }),
    t({ "", "" }),
    i(1, "input : Tensor"),
    t({ "", "    Description of input." }),
  }),
}
