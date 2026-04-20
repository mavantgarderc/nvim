local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"parforeach",
		fmt(
			[[
Parallel.ForEach({items}, item =>
{{
    {body}
}});
  ]],
			{
				items = ls.insert_node(1, "collection"),
				body = ls.insert_node(2, "// work"),
			}
		)
	),
}
