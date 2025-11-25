local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s({
    trig = "npmlds",
    name = "NumPy ML Dataset Loader Docstring",
    desc = "NumPy-style docstring for an ML dataset loading function.",
  }, {
    t({ '"""', "" }),
    i(1, "Load the dataset."),
    t({ "", "", "Returns", "-------" }),
    t({ "", "X : ndarray, shape (n_samples, n_features)" }),
    t({ "", "    Feature matrix." }),
    t({ "", "y : ndarray, shape (n_samples,)" }),
    t({ "", "    Target vector." }),
    t({ "", '"""' }),
  }),
}
