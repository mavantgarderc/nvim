local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	s({
		trig = "not",
		name = "Notes Section",
		desc = "Inserts a Notes section for additional information (common extension).",
	}, {
		t({ "", "Notes:", "    " }),
		i(1, "Additional notes..."),
	}),
}
