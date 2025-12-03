local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	s({
		trig = "npcdoc",
		name = "NumPy Class Docstring",
		desc = "NumPy-style docstring for classes.",
	}, {
		t({ '"""', "" }),
		i(1, "Short description of the class."),
		t({ "", "", "Attributes", "----------" }),
		t({ "", "" }),
		i(2, "attr1 : type"),
		t({ "", "    Description of attr1." }),
		t({ "", "", "Methods", "-------" }),
		t({ "", "" }),
		i(3, "method_name(param)"),
		t({ "", "    Short description of method." }),
		t({ "", '"""' }),
	}),
}
