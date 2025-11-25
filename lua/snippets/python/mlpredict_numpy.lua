local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s({
    trig = "npmlpred",
    name = "NumPy ML Predict Method Docstring",
    desc = "NumPy-style docstring for an ML model's predict method.",
  }, {
    t({ '"""', "" }),
    i(1, "Predict class labels for samples in X."),
    t({ "", "", "Parameters", "----------" }),
    t({ "", "X : array-like, shape (n_samples, n_features)" }),
    t({ "", "    Samples." }),
    t({ "", "", "Returns", "-------" }),
    t({ "", "y_pred : array-like, shape (n_samples,)" }),
    t({ "", "    Predicted class labels." }),
    t({ "", '"""' }),
  }),
}
