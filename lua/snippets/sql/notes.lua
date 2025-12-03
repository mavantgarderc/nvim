local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	s({
		trig = "not",
		name = "SQL Notes Doc Section",
		desc = "Section for additional notes or caveats.",
	}, {
		t({ " *", " * Notes: " }),
		i(1, "Additional notes..."),
	}),
}
