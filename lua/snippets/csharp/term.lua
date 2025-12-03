local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	s({
		trig = "term",
		name = "Term Inline Tag",
		desc = "Adds a <term> for list items within <list> or <listheader>.",
	}, {
		t("<term>"),
		i(1, "term"),
		t("</term>"),
	}),
}
