local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"dict",
		fmt(
			[[
var dict = new Dictionary<{K}, {V}>()
{{
    {{ {k}, {v} }}
}};
  ]],
			{
				K = ls.insert_node(1, "string"),
				V = ls.insert_node(2, "int"),
				k = ls.insert_node(3, '"key"'),
				v = ls.insert_node(4, "1"),
			}
		)
	),
}
