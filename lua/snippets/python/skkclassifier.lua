local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s({
    trig = "skclass",
    name = "scikit-learn Classifier Class Docstring",
    desc = "Full docstring for a scikit-learn classifier (e.g., LogisticRegression).",
  }, {
    t({ '"""', "" }),
    i(1, "Classifier using [algorithm]."),
    t({ "", "", "Parameters", "----------" }),
    t({ "", "" }),
    i(2, "penalty : {'l1', 'l2', 'elasticnet', None}, default='l2'"),
    t({ "", "    Used to specify the norm used in the penalization." }),
    t({ "", "", "Attributes", "----------" }),
    t({ "", "" }),
    i(3, "classes_ : ndarray of shape (n_classes,)"),
    t({ "", "    Unique class labels." }),
    t({ "", "coef_ : ndarray of shape (n_classes, n_features)" }),
    t({ "", "    Coefficients of the linear model." }),
    t({ "", "n_features_in_ : int" }),
    t({ "", "    Number of features seen during fit." }),
    t({ "", "", "Methods", "-------" }),
    t({ "", "fit(X, y)" }),
    t({ "", "    Fit the model according to the given training data." }),
    t({ "", "predict(X)" }),
    t({ "", "    Predict class labels for samples in X." }),
    t({ "", "predict_proba(X)" }),
    t({ "", "    Probability estimates." }),
    t({ "", "score(X, y)" }),
    t({ "", "    Return the mean accuracy on the given test data and labels." }),
    t({ "", '"""' }),
  }),
}
