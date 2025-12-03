local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	s({
		trig = "npmldl",
		name = "NumPy ML Data Loader Function Docstring",
		desc = "NumPy-style docstring for a data loader function (e.g., for batches).",
	}, {
		t({ '"""', "" }),
		i(1, "Generate batches of data for training."),
		t({ "", "", "Parameters", "----------" }),
		t({ "", "X : array-like, shape (n_samples, n_features)" }),
		t({ "", "    Input data." }),
		t({ "", "y : array-like, shape (n_samples,)" }),
		t({ "", "    Target values." }),
		t({ "", "batch_size : int, default=32" }),
		t({ "", "    Size of batches." }),
		t({ "", "", "Yields", "------" }),
		t({ "", "batch_X : ndarray, shape (batch_size, n_features)" }),
		t({ "", "    Batch of input data." }),
		t({ "", "batch_y : ndarray, shape (batch_size,)" }),
		t({ "", "    Batch of target values." }),
		t({ "", '"""' }),
	}),
}
