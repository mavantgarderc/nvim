local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	s({
		trig = "lh",
		name = "Listheader Inline Tag",
		desc = "Adds a <listheader> for table headers within <list> doc comments.",
	}, {
		t("/// <listheader>"),
		t({ "", "///   <term>" }),
		i(1, "term"),
		t("</term>"),
		t({ "", "///   <description>" }),
		i(2, "description"),
		t("</description>"),
		t({ "", "/// </listheader>" }),
	}),
}
