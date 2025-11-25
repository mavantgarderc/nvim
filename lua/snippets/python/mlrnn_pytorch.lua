local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s({
    trig = "ptrnn",
    name = "PyTorch RNN Layer Docstring",
    desc = "Docstring for RNN layers like nn.LSTM.",
  }, {
    t({ '"""', "" }),
    i(1, "Applies a multi-layer LSTM to an input sequence."),
    t({ "", "", "Parameters", "----------" }),
    t({ "", "input_size : int" }),
    t({ "", "    The number of expected features in the input." }),
    t({ "", "hidden_size : int" }),
    t({ "", "    The number of features in the hidden state." }),
    t({ "", "num_layers : int" }),
    t({ "", "    Number of recurrent layers." }),
    t({ "", "", "Returns", "-------" }),
    t({ "", "output, (h_n, c_n)" }),
    t({ "", "    Output and final hidden/cell states." }),
    t({ "", '"""' }),
  }),
}
