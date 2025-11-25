local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s({
    trig = "npmlopt",
    name = "NumPy ML Optimizer Class Docstring",
    desc = "NumPy-style docstring for an optimizer class (e.g., SGD).",
  }, {
    t({ '"""', "" }),
    i(1, "Stochastic Gradient Descent optimizer."),
    t({ "", "", "Parameters", "----------" }),
    t({ "", "learning_rate : float, default=0.01" }),
    t({ "", "    Step size shrinkage used in update to prevent overfitting." }),
    t({ "", "momentum : float, default=0.0" }),
    t({ "", "    Parameter that accelerates SGD in the relevant direction." }),
    t({ "", "", "Methods", "-------" }),
    t({ "", "update(params, grads)" }),
    t({ "", "    Update parameters using the computed gradients." }),
    t({ "", '"""' }),
  }),
}
