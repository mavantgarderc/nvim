local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"foreach",
		fmt(
			[[
foreach (var item in {items})
{{
    {body}
}}
  ]],
			{
				items = ls.insert_node(1, "list"),
				body = ls.insert_node(2, "// work"),
			}
		)
	),
}
