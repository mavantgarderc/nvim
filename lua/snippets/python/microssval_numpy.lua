local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	s({
		trig = "npmlcv",
		name = "NumPy ML Cross-Validation Function Docstring",
		desc = "NumPy-style docstring for a cross-validation utility function.",
	}, {
		t({ '"""', "" }),
		i(1, "Evaluate a score by cross-validation."),
		t({ "", "", "Parameters", "----------" }),
		t({ "", "estimator : estimator object implementing 'fit'" }),
		t({ "", "    The object to use to fit the data." }),
		t({ "", "X : array-like, shape (n_samples, n_features)" }),
		t({ "", "    The data to fit." }),
		t({ "", "y : array-like, shape (n_samples,)" }),
		t({ "", "    The target variable to try to predict." }),
		t({ "", "cv : int, default=5" }),
		t({ "", "    Number of folds." }),
		t({ "", "", "Returns", "-------" }),
		t({ "", "scores : ndarray of float, shape (n_splits,)" }),
		t({ "", "    Array of scores of the estimator for each run of the cross validation." }),
		t({ "", '"""' }),
	}),
}
