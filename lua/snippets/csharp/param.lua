-- csharp/param.lua
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	s({
		trig = "par",
		name = "Param Doc Comment",
		desc = "Adds a <param> XML documentation comment for parameters.",
	}, {
		t('/// <param name="'),
		i(1, "name"),
		t('">'),
		i(2, "description"),
		t("</param>"),
	}),
}
