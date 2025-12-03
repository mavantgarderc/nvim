local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	s({
		trig = "tpar",
		name = "Typeparam Doc Comment",
		desc = "Adds a <typeparam> XML documentation comment for type parameters.",
	}, {
		t('/// <typeparam name="'),
		i(1, "name"),
		t('">'),
		i(2, "description"),
		t("</typeparam>"),
	}),
}
