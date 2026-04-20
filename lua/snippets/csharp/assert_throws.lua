local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"assthrow",
		fmt(
			[[
Assert.Throws<{Exception}>(() =>
{{
    {body}
}});
  ]],
			{
				Exception = ls.insert_node(1, "Exception"),
				body = ls.insert_node(2, "// act"),
			}
		)
	),
}
