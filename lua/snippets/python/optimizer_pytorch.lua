local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s({
    trig = "ptopt",
    name = "PyTorch Optimizer Docstring",
    desc = "Docstring for optimizer setup functions.",
  }, {
    t({ '"""', "" }),
    i(1, "Sets up the optimizer for the model."),
    t({ "", "", "Parameters", "----------" }),
    t({ "", "model : nn.Module" }),
    t({ "", "    The model to optimize." }),
    t({ "", "lr : float, optional" }),
    t({ "", "    Learning rate. Default: 0.001." }),
    t({ "", "", "Returns", "-------" }),
    t({ "", "Optimizer" }),
    t({ "", "    The optimizer object." }),
    t({ "", '"""' }),
  }),
}
