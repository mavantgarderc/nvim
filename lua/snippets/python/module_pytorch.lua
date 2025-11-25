local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s({
    trig = "ptmodule",
    name = "PyTorch nn.Module Class Docstring",
    desc = "Docstring for custom nn.Module subclasses.",
  }, {
    t({ '"""', "" }),
    i(1, "A custom neural network module."),
    t({ "", "", "Parameters", "----------" }),
    t({ "", "" }),
    i(2, "param1 : int"),
    t({ "", "    Description of param1." }),
    t({ "", "", "Attributes", "----------" }),
    t({ "", "" }),
    i(3, "layer1 : nn.Module"),
    t({ "", "    Description of layer1." }),
    t({ "", "", "Methods", "-------" }),
    t({ "", "forward(input)" }),
    t({ "", "    Defines the computation performed at every call." }),
    t({ "", '"""' }),
  }),
}
