local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	s({
		trig = "val",
		name = "Value Doc Comment",
		desc = "Adds a <value> XML documentation comment for property values.",
	}, {
		t("/// <value>"),
		t({ "", "/// " }),
		i(1, "description"),
		t({ "", "/// </value>" }),
	}),
}
