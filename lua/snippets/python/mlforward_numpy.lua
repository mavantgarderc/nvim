local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s({
    trig = "npmlfwd",
    name = "NumPy ML Forward Pass Method Docstring",
    desc = "NumPy-style docstring for a neural network's forward pass method.",
  }, {
    t({ '"""', "" }),
    i(1, "Perform a forward pass through the network."),
    t({ "", "", "Parameters", "----------" }),
    t({ "", "X : array-like, shape (n_samples, n_features)" }),
    t({ "", "    Input data." }),
    t({ "", "", "Returns", "-------" }),
    t({ "", "output : ndarray, shape (n_samples, n_outputs)" }),
    t({ "", "    Output of the network." }),
    t({ "", '"""' }),
  }),
}
