local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	s({
		trig = "npmleval",
		name = "NumPy ML Evaluation Function Docstring",
		desc = "NumPy-style docstring for an ML evaluation metric function.",
	}, {
		t({ '"""', "" }),
		i(1, "Compute the mean squared error."),
		t({ "", "", "Parameters", "----------" }),
		t({ "", "y_true : array-like, shape (n_samples,)" }),
		t({ "", "    Ground truth values." }),
		t({ "", "y_pred : array-like, shape (n_samples,)" }),
		t({ "", "    Predicted values." }),
		t({ "", "", "Returns", "-------" }),
		t({ "", "mse : float" }),
		t({ "", "    Mean squared error." }),
		t({ "", '"""' }),
	}),
}
