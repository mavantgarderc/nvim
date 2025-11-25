local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s({
    trig = "skreg",
    name = "scikit-learn Regressor Class Docstring",
    desc = "Full docstring for a scikit-learn regressor (e.g., LinearRegression).",
  }, {
    t({ '"""', "" }),
    i(1, "Regressor using [algorithm]."),
    t({ "", "", "Parameters", "----------" }),
    t({ "", "" }),
    i(2, "fit_intercept : bool, default=True"),
    t({ "", "    Whether the intercept should be estimated or not." }),
    t({ "", "", "Attributes", "----------" }),
    t({ "", "" }),
    i(3, "coef_ : ndarray of shape (n_features,)"),
    t({ "", "    Estimated coefficients for the linear regression problem." }),
    t({ "", "intercept_ : float" }),
    t({ "", "    Independent term in the linear model." }),
    t({ "", "rank_ : int" }),
    t({ "", "    Rank of the fitted matrix." }),
    t({ "", "", "Methods", "-------" }),
    t({ "", "fit(X, y)" }),
    t({ "", "    Fit linear model." }),
    t({ "", "predict(X)" }),
    t({ "", "    Predict using the linear model." }),
    t({ "", "score(X, y)" }),
    t({ "", "    Return the coefficient of determination R^2 of the prediction." }),
    t({ "", '"""' }),
  }),
}
