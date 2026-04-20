local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"tc",
		fmt(
			[[
try {{
  {}
}} catch (error) {{
  console.error(error);
}}
]],
			{ i(1) }
		)
	),
}
