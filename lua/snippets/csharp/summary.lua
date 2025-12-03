local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	s({
		trig = "sum",
		name = "Summary Doc Comment",
		desc = "Adds a <summary> XML documentation comment for describing members.",
	}, {
		t("/// <summary>"),
		t({ "", "/// " }),
		i(1, "description"),
		t({ "", "/// </summary>" }),
	}),
}
