local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
	s({
		trig = "list",
		name = "List Doc Comment",
		desc = "Adds a <list> XML documentation comment for lists (bullet, number, table).",
	}, {
		t('/// <list type="'),
		i(1, "bullet"),
		t('">'),
		t({ "", "///   <item>" }),
		t({ "", "///     <description>" }),
		i(2, "Item 1."),
		t("</description>"),
		t({ "", "///   </item>" }),
		t({ "", "///   <item>" }),
		t({ "", "///     <description>" }),
		i(3, "Item 2."),
		t("</description>"),
		t({ "", "///   </item>" }),
		t({ "", "/// </list>" }),
	}),
}
