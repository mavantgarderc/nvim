local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"dicttry",
		fmt(
			[[
if ({dict}.TryGetValue({key}, out var value))
{{
    {body}
}}
  ]],
			{
				dict = ls.insert_node(1, "dict"),
				key = ls.insert_node(2, '"k"'),
				body = ls.insert_node(3, "// use value"),
			}
		)
	),
}
