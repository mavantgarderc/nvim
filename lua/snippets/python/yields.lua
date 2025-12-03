local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	s({
		trig = "yie",
		name = "Yields Section",
		desc = "Inserts the Yields section for generators.",
	}, {
		t({ "", "Yields:", "    " }),
		i(1, "Description of yielded value."),
	}),
}
