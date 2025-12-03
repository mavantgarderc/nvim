local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	s({
		trig = "para",
		name = "Para Inline Tag",
		desc = "Adds a <para> inline tag for paragraphs within doc comments.",
	}, {
		t("/// <para>"),
		t({ "", "/// " }),
		i(1, "content"),
		t({ "", "/// </para>" }),
	}),
}
