local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	s({
		trig = "ptkw",
		name = "PyTorch Keyword Arguments Section",
		desc = "Inserts a Keyword Arguments section in PyTorch style.",
	}, {
		t({ "", "Keyword Arguments", "-----------------" }),
		t({ "", "" }),
		i(1, "dtype : torch.dtype, optional"),
		t({ "", "    The desired data type. Default: None." }),
	}),
}
