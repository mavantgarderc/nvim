local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s({
    trig = "ptrandn",
    name = "PyTorch randn Docstring",
    desc = "Docstring for functions like torch.randn.",
  }, {
    t({ '"""', "" }),
    i(1, "Returns a tensor filled with random numbers from a normal distribution."),
    t({ "", "", "Parameters", "----------" }),
    t({ "", "*size : int..." }),
    t({ "", "    A sequence of integers defining the shape of the output tensor." }),
    t({ "", "", "Keyword Arguments", "-----------------" }),
    t({ "", "dtype : " }),
    i(2, "torch.dtype, optional"),
    t({ "", "    The desired data type. Default: torch.float32." }),
    t({ "", "device : " }),
    i(3, "torch.device, optional"),
    t({ "", "    The desired device. Default: current device." }),
    t({ "", "requires_grad : " }),
    i(4, "bool, optional"),
    t({ "", "    If autograd should record operations. Default: False." }),
    t({ "", "out : " }),
    i(5, "Tensor, optional"),
    t({ "", "    The output tensor." }),
    t({ "", "", "Returns", "-------" }),
    t({ "", "Tensor" }),
    t({ "", "    Tensor of random numbers." }),
    t({ "", '"""' }),
  }),
}
