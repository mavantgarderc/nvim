local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	s({
		trig = "mldoc",
		name = "ML Model Docstring",
		desc = "Extended docstring for ML models or functions, including parameters and examples.",
	}, {
		t({ '"""', "" }),
		i(1, "One-line summary of the model."),
		t({ "", "", "Args:", "    " }),
		i(2, "X"),
		t(": Input data."),
		t({ "", "    " }),
		i(3, "y"),
		t(": Target labels."),
		t({ "", "", "Returns:", "    " }),
		i(4, "Trained model or predictions."),
		t({ "", "", "Examples:", "    >>> model = " }),
		i(5, "MyModel()"),
		t({ "", "    >>> model.fit(X, y)" }),
		t({ "", '"""' }),
	}),
}
