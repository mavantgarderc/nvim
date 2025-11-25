local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s({
    trig = "npmlfit",
    name = "NumPy ML Fit Method Docstring",
    desc = "NumPy-style docstring for an ML model's fit method.",
  }, {
    t({ '"""', "" }),
    i(1, "Fit the model according to the given training data."),
    t({ "", "", "Parameters", "----------" }),
    t({ "", "X : array-like, shape (n_samples, n_features)" }),
    t({ "", "    Training vector." }),
    t({ "", "y : array-like, shape (n_samples,)" }),
    t({ "", "    Target vector." }),
    t({ "", "", "Returns", "-------" }),
    t({ "", "self : object" }),
    t({ "", "    Returns self." }),
    t({ "", '"""' }),
  }),
}
