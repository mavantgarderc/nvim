local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s({
    trig = "sktrans",
    name = "scikit-learn Transformer Class Docstring",
    desc = "Full docstring for a scikit-learn transformer (e.g., StandardScaler).",
  }, {
    t({ '"""', "" }),
    i(1, "Standardize features by removing the mean and scaling to unit variance."),
    t({ "", "", "Parameters", "----------" }),
    t({ "", "" }),
    i(2, "with_mean : bool, default=True"),
    t({ "", "    If True, center the data before scaling." }),
    t({ "", "", "Attributes", "----------" }),
    t({ "", "" }),
    i(3, "mean_ : ndarray of shape (n_features,)"),
    t({ "", "    Per feature adjustment for mean." }),
    t({ "", "scale_ : ndarray of shape (n_features,)" }),
    t({ "", "    Per feature relative scaling of the data." }),
    t({ "", "n_features_in_ : int" }),
    t({ "", "    Number of features seen during fit." }),
    t({ "", "", "Methods", "-------" }),
    t({ "", "fit(X[, y])" }),
    t({ "", "    Compute the mean and std to be used for later scaling." }),
    t({ "", "transform(X)" }),
    t({ "", "    Perform standardization by centering and scaling." }),
    t({ "", "fit_transform(X[, y])" }),
    t({ "", "    Fit to data, then transform it." }),
    t({ "", '"""' }),
  }),
}
