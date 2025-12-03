local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	s({
		trig = "npmlnn",
		name = "NumPy ML Neural Network Class Docstring",
		desc = "NumPy-style docstring for a simple neural network class.",
	}, {
		t({ '"""', "" }),
		i(1, "A simple multi-layer perceptron neural network."),
		t({ "", "", "Parameters", "----------" }),
		t({ "", "hidden_layer_sizes : tuple, default=(100,)" }),
		t({ "", "    The ith element represents the number of neurons in the ith hidden layer." }),
		t({ "", "activation : {'identity', 'logistic', 'tanh', 'relu'}, default='relu'" }),
		t({ "", "    Activation function for the hidden layer." }),
		t({ "", "", "Attributes", "----------" }),
		t({ "", "coefs_ : list of ndarray" }),
		t({ "", "    The ith element in the list represents the weight matrix corresponding to layer i." }),
		t({ "", "", "Methods", "-------" }),
		t({ "", "fit(X, y)" }),
		t({ "", "    Fit the model to data matrix X and target(s) y." }),
		t({ "", "predict(X)" }),
		t({ "", "    Predict using the multi-layer perceptron classifier." }),
		t({ "", '"""' }),
	}),
}
