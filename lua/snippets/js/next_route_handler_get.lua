local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"nget",
		fmt(
			[[
export async function GET(request) {{
  return Response.json({{
    {}
  }});
}}
]],
			{ i(1, "message: 'ok'") }
		)
	),
}
