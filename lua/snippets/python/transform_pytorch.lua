local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	s({
		trig = "pttrans",
		name = "PyTorch Transform Docstring",
		desc = "Docstring for data transform classes or functions.",
	}, {
		t({ '"""', "" }),
		i(1, "Applies transformations to the data."),
		t({ "", "", "Parameters", "----------" }),
		t({ "", "sample : dict or Tensor" }),
		t({ "", "    The input sample." }),
		t({ "", "", "Returns", "-------" }),
		t({ "", "dict or Tensor" }),
		t({ "", "    Transformed sample." }),
		t({ "", '"""' }),
	}),
}
