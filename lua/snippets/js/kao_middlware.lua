local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"koa",
		fmt(
			[[
async function {}(ctx, next) {{
  {}
  await next();
}}
]],
			{ i(1, "middleware"), i(2, "// logic") }
		)
	),
}
