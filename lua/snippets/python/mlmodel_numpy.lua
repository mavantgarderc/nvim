local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s({
    trig = "npmlmod",
    name = "NumPy ML Model Class Docstring",
    desc = "NumPy-style docstring for an ML model class (e.g., scikit-learn like).",
  }, {
    t({ '"""', "" }),
    i(1, "Short description of the ML model."),
    t({ "", "", "Parameters", "----------" }),
    t({ "", "" }),
    i(2, "learning_rate : float, default=0.01"),
    t({ "", "    The learning rate for optimization." }),
    t({ "", "", "Attributes", "----------" }),
    t({ "", "" }),
    i(3, "coef_ : array-like"),
    t({ "", "    Coefficients after fitting." }),
    t({ "", "", "Methods", "-------" }),
    t({ "", "fit(X, y)" }),
    t({ "", "    Fit the model to the data." }),
    t({ "", "predict(X)" }),
    t({ "", "    Predict using the fitted model." }),
    t({ "", '"""' }),
  }),
}
