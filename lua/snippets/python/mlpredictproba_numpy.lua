local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	s({
		trig = "npmlpredproba",
		name = "NumPy ML Predict Proba Method Docstring",
		desc = "NumPy-style docstring for an ML model's predict_proba method.",
	}, {
		t({ '"""', "" }),
		i(1, "Predict class probabilities for X."),
		t({ "", "", "Parameters", "----------" }),
		t({ "", "X : array-like, shape (n_samples, n_features)" }),
		t({ "", "    Samples." }),
		t({ "", "", "Returns", "-------" }),
		t({ "", "proba : ndarray, shape (n_samples, n_classes)" }),
		t({ "", "    Probability of the sample for each class in the model." }),
		t({ "", '"""' }),
	}),
}
