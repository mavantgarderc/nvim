local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s({
    trig = "npmlprep",
    name = "NumPy ML Preprocessing Function Docstring",
    desc = "NumPy-style docstring for a data preprocessing function (e.g., normalization).",
  }, {
    t({ '"""', "" }),
    i(1, "Normalize samples individually to unit norm."),
    t({ "", "", "Parameters", "----------" }),
    t({ "", "X : array-like, shape (n_samples, n_features)" }),
    t({ "", "    The data to normalize." }),
    t({ "", "norm : {'l1', 'l2', 'max'}, default='l2'" }),
    t({ "", "    The norm to use to normalize each non zero sample." }),
    t({ "", "", "Returns", "-------" }),
    t({ "", "X_normalized : array-like, shape (n_samples, n_features)" }),
    t({ "", "    Normalized data." }),
    t({ "", '"""' }),
  }),
}
