local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s({
    trig = "skpred",
    name = "scikit-learn Predict Method Docstring",
    desc = "Standard docstring for the predict method.",
  }, {
    t({ '"""', "" }),
    i(1, "Predict class labels for samples in X."),
    t({ "", "", "Parameters", "----------" }),
    t({ "", "X : {array-like, sparse matrix} of shape (n_samples, n_features)" }),
    t({ "", "    The input samples." }),
    t({ "", "", "Returns", "-------" }),
    t({ "", "y : ndarray of shape (n_samples,)" }),
    t({ "", "    The predicted classes." }),
    t({ "", '"""' }),
  }),
}
