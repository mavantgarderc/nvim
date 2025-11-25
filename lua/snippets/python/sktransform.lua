local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s({
    trig = "sktransf",
    name = "scikit-learn Transform Method Docstring",
    desc = "Standard docstring for the transform method in transformers.",
  }, {
    t({ '"""', "" }),
    i(1, "Transform the data."),
    t({ "", "", "Parameters", "----------" }),
    t({ "", "X : {array-like, sparse matrix} of shape (n_samples, n_features)" }),
    t({ "", "    The input samples." }),
    t({ "", "", "Returns", "-------" }),
    t({ "", "X_new : ndarray of shape (n_samples, n_features_new)" }),
    t({ "", "    The transformed data." }),
    t({ "", '"""' }),
  }),
}
