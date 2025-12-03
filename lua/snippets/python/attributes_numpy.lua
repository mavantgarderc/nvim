local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	s({
		trig = "npatt",
		name = "NumPy Attributes Section",
		desc = "Inserts an Attributes section in NumPy style for classes.",
	}, {
		t({ "", "Attributes", "----------" }),
		t({ "", "" }),
		i(1, "attr1 : type"),
		t({ "", "    Description of attr1." }),
	}),
}
