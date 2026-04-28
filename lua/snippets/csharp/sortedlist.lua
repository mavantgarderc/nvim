local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"sortedlist",
		fmt(
			[[
var sorted = new SortedList<{K}, {V}>()
{{
    {{ {k}, {v} }}
}};
  ]],
			{
				K = ls.insert_node(1, "int"),
				V = ls.insert_node(2, "string"),
				k = ls.insert_node(3, "1"),
				v = ls.insert_node(4, '"hello"'),
			}
		)
	),
}
