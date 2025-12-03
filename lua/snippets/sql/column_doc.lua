local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	s({
		trig = "cdoc",
		name = "SQL Column Doc Comment",
		desc = "Inline comment for documenting a single column.",
	}, {
		t(" -- "),
		i(1, "column_name"),
		t(" "),
		i(2, "datatype"),
		t(": "),
		i(3, "Description of the column."),
	}),
}
