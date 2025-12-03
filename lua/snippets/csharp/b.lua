local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	s({
		trig = "b",
		name = "Bold Inline Tag",
		desc = "Makes text bold within documentation comments.",
	}, {
		t("<b>"),
		i(1, "text"),
		t("</b>"),
	}),
}
