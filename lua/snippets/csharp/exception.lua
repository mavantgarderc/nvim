local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	s({
		trig = "exc",
		name = "Exception Doc Comment",
		desc = "Adds an <exception> XML documentation comment for exceptions.",
	}, {
		t('/// <exception cref="'),
		i(1, "member"),
		t('">'),
		i(2, "description"),
		t("</exception>"),
	}),
}
