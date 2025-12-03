local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	s({
		trig = "skest",
		name = "scikit-learn Estimator Class Docstring",
		desc = "Full NumPy-style docstring for a general scikit-learn estimator class (base for classifiers/regressors).",
	}, {
		t({ '"""', "" }),
		i(1, "Short description of the estimator."),
		t({ "", "", "Parameters", "----------" }),
		t({ "", "" }),
		i(2, "param_name : type, default=value"),
		t({ "", "    Description of the parameter." }),
		t({ "", "", "Attributes", "----------" }),
		t({ "", "" }),
		i(3, "coef_ : ndarray of shape (n_features,)"),
		t({ "", "    Coefficients of the estimator." }),
		t({ "", "intercept_ : ndarray of shape (1,)" }),
		t({ "", "    Bias (intercept) of the estimator." }),
		t({ "", "", "Methods", "-------" }),
		t({ "", "fit(X, y)" }),
		t({ "", "    Fit the estimator." }),
		t({ "", "predict(X)" }),
		t({ "", "    Predict using the estimator." }),
		t({ "", "score(X, y)" }),
		t({ "", "    Return the coefficient of determination R^2 of the prediction." }),
		t({ "", '"""' }),
	}),
}
