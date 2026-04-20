local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"ule",
		fmt(
			[[
React.useLayoutEffect(() => {{
  {body}
}}, [{deps}]);
  ]],
			{
				body = ls.insert_node(1, "// layout work"),
				deps = ls.insert_node(2, ""),
			}
		)
	),
}
