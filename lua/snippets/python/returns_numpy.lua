local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	s({
		trig = "npret",
		name = "NumPy Returns Section",
		desc = "Inserts a Returns section in NumPy style.",
	}, {
		t({ "", "Returns", "-------" }),
		t({ "", "" }),
		i(1, "return_type"),
		t({ "", "    Description of return value." }),
	}),
}
