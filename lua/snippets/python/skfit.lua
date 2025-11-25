local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s({
    trig = "skfit",
    name = "scikit-learn Fit Method Docstring",
    desc = "Standard docstring for the fit method in estimators.",
  }, {
    t({ '"""', "" }),
    i(1, "Fit the model according to the given training data."),
    t({ "", "", "Parameters", "----------" }),
    t({ "", "X : {array-like, sparse matrix} of shape (n_samples, n_features)" }),
    t({
      "",
      "    Training vector, where `n_samples` is the number of samples and `n_features` is the number of features.",
    }),
    t({ "", "y : array-like of shape (n_samples,)" }),
    t({ "", "    Target values (integers for classification, real numbers for regression)." }),
    t({ "", "", "Returns", "-------" }),
    t({ "", "self : object" }),
    t({ "", "    Fitted estimator." }),
    t({ "", '"""' }),
  }),
}
