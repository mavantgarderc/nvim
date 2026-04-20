local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"rhget",
		fmt(
			[[
export async function GET(request) {{
  return Response.json({data});
}}
  ]],
			{
				data = ls.insert_node(1, "{ message: 'ok' }"),
			}
		)
	),
}
