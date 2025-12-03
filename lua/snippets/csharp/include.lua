local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	s({
		trig = "inc",
		name = "Include Doc Comment",
		desc = "Adds an <include> XML documentation comment for external files.",
	}, {
		t('/// <include file="'),
		i(1, "filename"),
		t('" path="'),
		i(2, "xpath"),
		t('" />'),
	}),
}
