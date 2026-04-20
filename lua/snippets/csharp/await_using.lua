local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"awaitusing",
		fmt(
			[[
await using var {res} = {expr};
{{
  {body}
}}
  ]],
			{
				res = ls.insert_node(1, "resource"),
				expr = ls.insert_node(2, "new AsyncDisposable()"),
				body = ls.insert_node(3, "// operations"),
			}
		)
	),
}
