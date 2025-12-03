local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	s({
		trig = "npmlbp",
		name = "NumPy ML Backpropagation Function Docstring",
		desc = "NumPy-style docstring for a backpropagation utility function.",
	}, {
		t({ '"""', "" }),
		i(1, "Compute gradients using backpropagation."),
		t({ "", "", "Parameters", "----------" }),
		t({ "", "activations : list of ndarray" }),
		t({ "", "    Activations from forward pass." }),
		t({ "", "y : array-like, shape (n_samples, n_outputs)" }),
		t({ "", "    Target values." }),
		t({ "", "", "Returns", "-------" }),
		t({ "", "gradients : list of ndarray" }),
		t({ "", "    Gradients for each layer." }),
		t({ "", '"""' }),
	}),
}
