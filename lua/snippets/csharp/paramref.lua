local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	s({
		trig = "parref",
		name = "Paramref Inline Tag",
		desc = "Adds a <paramref> inline tag referencing a parameter.",
	}, {
		t('<paramref name="'),
		i(1, "name"),
		t('" />'),
	}),
}
