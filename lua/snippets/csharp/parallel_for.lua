local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"parfor",
		fmt(
			[[
Parallel.For(0, {count}, i =>
{{
    {body}
}});
  ]],
			{
				count = ls.insert_node(1, "100"),
				body = ls.insert_node(2, "// work"),
			}
		)
	),
}
