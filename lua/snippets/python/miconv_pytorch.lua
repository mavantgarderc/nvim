local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	s({
		trig = "ptconv",
		name = "PyTorch Conv Layer Docstring",
		desc = "Docstring for convolutional layers like nn.Conv2d.",
	}, {
		t({ '"""', "" }),
		i(1, "2D convolution layer."),
		t({ "", "", "Parameters", "----------" }),
		t({ "", "in_channels : int" }),
		t({ "", "    Number of channels in the input image." }),
		t({ "", "out_channels : int" }),
		t({ "", "    Number of channels produced by the convolution." }),
		t({ "", "kernel_size : int or tuple" }),
		t({ "", "    Size of the convolving kernel." }),
		t({ "", "", "Returns", "-------" }),
		t({ "", "Tensor" }),
		t({ "", "    Convolved tensor." }),
		t({ "", '"""' }),
	}),
}
