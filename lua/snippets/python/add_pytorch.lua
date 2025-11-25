local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s({
    trig = "ptadd",
    name = "PyTorch Add Operation Docstring",
    desc = "Docstring for tensor operations like torch.add.",
  }, {
    t({ '"""', "" }),
    i(1, "Adds other, scaled by alpha, to input."),
    t({ "", "", "Parameters", "----------" }),
    t({ "", "input : Tensor" }),
    t({ "", "    The input tensor." }),
    t({ "", "other : Tensor or Number" }),
    t({ "", "    The tensor or number to add." }),
    t({ "", "", "Keyword Arguments", "-----------------" }),
    t({ "", "alpha : " }),
    i(2, "Number, optional"),
    t({ "", "    The multiplier for other. Default: 1." }),
    t({ "", "out : " }),
    i(3, "Tensor, optional"),
    t({ "", "    The output tensor." }),
    t({ "", "", "Returns", "-------" }),
    t({ "", "Tensor" }),
    t({ "", "    The result of the addition." }),
    t({ "", "", "Examples", "--------" }),
    t({ "", ">>> torch.add(" }),
    i(4, "tensor([1, 2]), tensor([3, 4])"),
    t({ "", "tensor([4, 6])" }),
    t({ "", '"""' }),
  }),
}
