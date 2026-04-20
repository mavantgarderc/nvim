local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"awt",
		fmt(
			[[
try {{
  const {} = await {};
  {}
}} catch (err) {{
  console.error(err);
}}
]],
			{ i(1, "result"), i(2, "promise"), i(3) }
		)
	),
}
