local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	s({
		trig = "vdoc",
		name = "SQL View Doc Comment",
		desc = "Multi-line comment block for documenting a view.",
	}, {
		t({ "/**", " * View: " }),
		i(1, "ViewName"),
		t({ "", " *", " * Description: " }),
		i(2, "Brief description of the view."),
		t({ "", " *", " * Based On: " }),
		i(3, "Tables or other views."),
		t({ "", " *", " * Example:", " *   SELECT * FROM ViewName;", " */" }),
	}),
}
