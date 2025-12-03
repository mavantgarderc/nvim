local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	s({
		trig = "tparref",
		name = "Typeparamref Inline Tag",
		desc = "Adds a <typeparamref> inline tag referencing a type parameter.",
	}, {
		t('<typeparamref name="'),
		i(1, "name"),
		t('" />'),
	}),
}
