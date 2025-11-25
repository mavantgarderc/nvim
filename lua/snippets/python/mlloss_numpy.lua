local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s({
    trig = "npmlloss",
    name = "NumPy ML Loss Function Docstring",
    desc = "NumPy-style docstring for a loss function (e.g., in optimization).",
  }, {
    t({ '"""', "" }),
    i(1, "Compute the log loss (cross-entropy loss)."),
    t({ "", "", "Parameters", "----------" }),
    t({ "", "y_true : array-like, shape (n_samples,)" }),
    t({ "", "    True binary labels." }),
    t({ "", "y_pred : array-like, shape (n_samples,)" }),
    t({ "", "    Predicted probabilities." }),
    t({ "", "", "Returns", "-------" }),
    t({ "", "loss : float" }),
    t({ "", "    Log loss." }),
    t({ "", '"""' }),
  }),
}
