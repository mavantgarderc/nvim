local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"hashset",
		fmt(
			[[
var set = new HashSet<{T}>({{
    {vals}
}});
  ]],
			{
				T = ls.insert_node(1, "string"),
				vals = ls.insert_node(2, '"a", "b"'),
			}
		)
	),
}
