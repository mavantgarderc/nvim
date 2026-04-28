local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"alambda",
		fmt(
			[[
async ({params}) =>
{{
  {body}
}}
  ]],
			{
				params = ls.insert_node(1, ""),
				body = ls.insert_node(2, "await Task.CompletedTask;"),
			}
		)
	),
}
