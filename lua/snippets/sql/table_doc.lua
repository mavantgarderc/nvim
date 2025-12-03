local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	s({
		trig = "tdoc",
		name = "SQL Table Doc Comment",
		desc = "Multi-line comment block for documenting a table.",
	}, {
		t({ "/**", " * Table: " }),
		i(1, "TableName"),
		t({ "", " *", " * Description: " }),
		i(2, "Brief description of the table."),
		t({ "", " *", " * Columns:", " *   column1 " }),
		i(3, "datatype"),
		t(" - "),
		i(4, "Description of column1."),
		t({ "", " *", " * Indexes:", " *   " }),
		i(5, "Index details."),
		t({ "", " *", " * Example:", " *   SELECT * FROM TableName;", " */" }),
	}),
}
