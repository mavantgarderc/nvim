local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	s({
		trig = "rem",
		name = "Remarks Doc Comment",
		desc = "Adds a <remarks> XML documentation comment for additional information.",
	}, {
		t("/// <remarks>"),
		t({ "", "/// " }),
		i(1, "description"),
		t({ "", "/// </remarks>" }),
	}),
}
