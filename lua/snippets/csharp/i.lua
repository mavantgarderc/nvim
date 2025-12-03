local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	s({
		trig = "it",
		name = "Italic Inline Tag",
		desc = "Makes text italic within documentation comments.",
	}, {
		t("<i>"),
		i(1, "text"),
		t("</i>"),
	}),
}
