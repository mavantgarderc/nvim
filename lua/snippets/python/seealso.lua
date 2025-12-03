local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	s({
		trig = "see",
		name = "See Also Section",
		desc = "Inserts a See Also section for related functions/classes (common extension).",
	}, {
		t({ "", "See Also:", "    " }),
		i(1, "related_function: Description."),
	}),
}
