local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	s({
		trig = "ptfwd",
		name = "PyTorch Forward Method Docstring",
		desc = "Docstring for the forward method in nn.Module.",
	}, {
		t({ '"""', "" }),
		i(1, "Defines the computation performed at every call."),
		t({ "", "", "Parameters", "----------" }),
		t({ "", "input : Tensor" }),
		t({ "", "    Input tensor of shape (batch_size, ...)." }),
		t({ "", "", "Returns", "-------" }),
		t({ "", "Tensor" }),
		t({ "", "    Output tensor." }),
		t({ "", '"""' }),
	}),
}
