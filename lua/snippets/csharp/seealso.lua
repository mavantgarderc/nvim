local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	s({
		trig = "seealso",
		name = "Seealso Doc Comment",
		desc = "Adds a <seealso> XML documentation comment for related references.",
	}, {
		t('/// <seealso cref="'),
		i(1, "member"),
		t('" />'),
	}),
}
