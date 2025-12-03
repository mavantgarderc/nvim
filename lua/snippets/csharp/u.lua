local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	s({
		trig = "u",
		name = "Underline Inline Tag",
		desc = "Underlines text within documentation comments.",
	}, {
		t("<u>"),
		i(1, "text"),
		t("</u>"),
	}),
}
