local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s({
    trig = "npmlscore",
    name = "NumPy ML Score Method Docstring",
    desc = "NumPy-style docstring for an ML model's score method.",
  }, {
    t({ '"""', "" }),
    i(1, "Return the mean accuracy on the given test data and labels."),
    t({ "", "", "Parameters", "----------" }),
    t({ "", "X : array-like, shape (n_samples, n_features)" }),
    t({ "", "    Test samples." }),
    t({ "", "y : array-like, shape (n_samples,)" }),
    t({ "", "    True labels for X." }),
    t({ "", "", "Returns", "-------" }),
    t({ "", "score : float" }),
    t({ "", "    Mean accuracy of self.predict(X) wrt. y." }),
    t({ "", '"""' }),
  }),
}
