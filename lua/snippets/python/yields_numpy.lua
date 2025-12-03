local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	s({
		trig = "npyie",
		name = "NumPy Yields Section",
		desc = "Inserts a Yields section in NumPy style for generators.",
	}, {
		t({ "", "Yields", "------" }),
		t({ "", "" }),
		i(1, "yield_type"),
		t({ "", "    Description of yielded value." }),
	}),
}
