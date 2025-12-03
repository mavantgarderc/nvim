local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	s({
		trig = "att",
		name = "Attributes Section",
		desc = "Inserts the Attributes section for classes with an example attribute.",
	}, {
		t({ "", "Attributes:", "    " }),
		i(1, "attr1"),
		t(": "),
		i(2, "Description of attr1."),
	}),
}
