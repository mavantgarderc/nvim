local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	s({
		trig = "npmlpartfit",
		name = "NumPy ML Partial Fit Method Docstring",
		desc = "NumPy-style docstring for an ML model's partial_fit method (for online learning).",
	}, {
		t({ '"""', "" }),
		i(1, "Update the model with a single iteration over the given data."),
		t({ "", "", "Parameters", "----------" }),
		t({ "", "X : array-like, shape (n_samples, n_features)" }),
		t({ "", "    Training vector." }),
		t({ "", "y : array-like, shape (n_samples,)" }),
		t({ "", "    Target vector." }),
		t({ "", "", "Returns", "-------" }),
		t({ "", "self : object" }),
		t({ "", "    Returns a trained model." }),
		t({ "", '"""' }),
	}),
}
