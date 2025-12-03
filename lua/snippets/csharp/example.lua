local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	s({
		trig = "ex",
		name = "Example Doc Comment",
		desc = "Adds an <example> XML documentation comment for usage examples.",
	}, {
		t("/// <example>"),
		t({ "", "/// " }),
		i(1, "description"),
		t({ "", "/// </example>" }),
	}),
}
