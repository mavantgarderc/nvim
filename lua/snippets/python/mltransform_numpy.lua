local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s({
    trig = "npmltrans",
    name = "NumPy ML Transform Method Docstring",
    desc = "NumPy-style docstring for an ML preprocessor's transform method.",
  }, {
    t({ '"""', "" }),
    i(1, "Transform the data."),
    t({ "", "", "Parameters", "----------" }),
    t({ "", "X : array-like, shape (n_samples, n_features)" }),
    t({ "", "    Input data." }),
    t({ "", "", "Returns", "-------" }),
    t({ "", "X_transformed : array-like, shape (n_samples, n_features)" }),
    t({ "", "    Transformed data." }),
    t({ "", '"""' }),
  }),
}
