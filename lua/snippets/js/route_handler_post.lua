local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"rhpost",
		fmt(
			[[
export async function POST(request) {{
  const body = await request.json();
  {logic}
  return Response.json({response});
}}
  ]],
			{
				logic = ls.insert_node(1, "// process body"),
				response = ls.insert_node(2, "{ status: 'ok' }"),
			}
		)
	),
}
