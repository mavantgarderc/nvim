local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s({
    trig = "skscore",
    name = "scikit-learn Score Method Docstring",
    desc = "Standard docstring for the score method (R^2 for regressors, accuracy for classifiers).",
  }, {
    t({ '"""', "" }),
    i(1, "Return the coefficient of determination R^2 of the prediction."),
    t({ "", "", "The coefficient R^2 is defined as (1 - u/v), where u is the residual" }),
    t({ "", "sum of squares ((y_true - y_pred) ** 2).sum() and v is the total" }),
    t({ "", "sum of squares ((y_true - y_mean) ** 2).sum(). The best possible score" }),
    t({ "", "is 1.0 and it can be negative (because the model can be arbitrarily worse)." }),
    t({ "", "A constant model that always predicts the expected value of y, disregarding" }),
    t({ "", "the input features, would get a R^2 score of 0.0." }),
    t({ "", "", "Parameters", "----------" }),
    t({ "", "X : array-like of shape (n_samples, n_features)" }),
    t({ "", "    Test samples." }),
    t({ "", "y : array-like of shape (n_samples,) or (n_samples, n_outputs)" }),
    t({ "", "    True values for X." }),
    t({ "", "", "Returns", "-------" }),
    t({ "", "score : float" }),
    t({ "", "    R^2 of self.predict(X) wrt. y." }),
    t({ "", '"""' }),
  }),
}
