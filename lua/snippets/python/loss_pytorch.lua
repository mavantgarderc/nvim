local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s({
    trig = "ptloss",
    name = "PyTorch Loss Function Docstring",
    desc = "Docstring for custom loss functions.",
  }, {
    t({ '"""', "" }),
    i(1, "Computes the loss between input and target."),
    t({ "", "", "Parameters", "----------" }),
    t({ "", "input : Tensor" }),
    t({ "", "    Predicted tensor." }),
    t({ "", "target : Tensor" }),
    t({ "", "    Ground truth tensor." }),
    t({ "", "", "Returns", "-------" }),
    t({ "", "Tensor" }),
    t({ "", "    The calculated loss." }),
    t({ "", '"""' }),
  }),
}
