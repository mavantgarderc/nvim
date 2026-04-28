local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"npost",
		fmt(
			[[
export async function POST(request) {{
  const body = await request.json();
  return Response.json({{
    received: body
  }});
}}
]],
			{}
		)
	),
}
