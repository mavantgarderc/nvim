local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	s({
		trig = "npdoc",
		name = "NumPy Function Docstring",
		desc = "Basic NumPy-style docstring for functions.",
	}, {
		t({ '"""', "" }),
		i(1, "Short description."),
		t({ "", "", "Parameters", "----------" }),
		t({ "", "" }),
		i(2, "param1 : type"),
		t({ "", "    Description of param1." }),
		t({ "", "", "Returns", "-------" }),
		t({ "", "" }),
		i(3, "return_type"),
		t({ "", "    Description of return value." }),
		t({ "", '"""' }),
	}),
}
