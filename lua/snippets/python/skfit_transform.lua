local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	s({
		trig = "skft",
		name = "scikit-learn Fit_Transform Method Docstring",
		desc = "Standard docstring for the fit_transform method.",
	}, {
		t({ '"""', "" }),
		i(1, "Fit to data, then transform it."),
		t({ "", "", "Fits transformer to X and y with optional parameters `fit_params`" }),
		t({ "", "and returns a transformed version of X." }),
		t({ "", "", "Parameters", "----------" }),
		t({ "", "X : {array-like, sparse matrix} of shape (n_samples, n_features)" }),
		t({ "", "    Input samples." }),
		t({ "", "y : array-like of shape (n_samples,) or (n_samples, n_targets), default=None" }),
		t({ "", "    Targets for supervised learning." }),
		t({ "", "", "Returns", "-------" }),
		t({ "", "X_new : ndarray array of shape (n_samples, n_features_new)" }),
		t({ "", "    Transformed array." }),
		t({ "", '"""' }),
	}),
}
