local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s({
    trig = "pttensor",
    name = "PyTorch Tensor Creation Docstring",
    desc = "NumPy-style docstring for PyTorch tensor creation functions like torch.tensor.",
  }, {
    t({ '"""', "" }),
    i(1, "Constructs a tensor with data."),
    t({ "", "", "Parameters", "----------" }),
    t({ "", "data : array_like" }),
    t({ "", "    Initial data for the tensor. Can be a list, tuple, NumPy ndarray, scalar, etc." }),
    t({ "", "", "Keyword Arguments", "-----------------" }),
    t({ "", "dtype : " }),
    i(2, "torch.dtype, optional"),
    t({ "", "    The desired data type of returned tensor. Default: infers from data." }),
    t({ "", "device : " }),
    i(3, "torch.device, optional"),
    t({ "", "    The device of the constructed tensor. Default: current device." }),
    t({ "", "requires_grad : " }),
    i(4, "bool, optional"),
    t({ "", "    If autograd should record operations. Default: False." }),
    t({ "", "pin_memory : " }),
    i(5, "bool, optional"),
    t({ "", "    If set, tensor allocated in pinned memory (CPU only). Default: False." }),
    t({ "", "", "Returns", "-------" }),
    t({ "", "Tensor" }),
    t({ "", "    A new tensor." }),
    t({ "", "", "Examples", "--------" }),
    t({ "", ">>> torch.tensor(" }),
    i(6, "[[1, 2], [3, 4]]"),
    t({ "", "tensor([[1, 2], [3, 4]])" }),
    t({ "", '"""' }),
  }),
}
