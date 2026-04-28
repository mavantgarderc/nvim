local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"nmid",
		fmt(
			[[
import {{ NextResponse }} from 'next/server';

export function middleware(request) {{
  {}
  return NextResponse.next();
}}
]],
			{ i(1, "// logic") }
		)
	),
}
