local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"hook",
		fmt(
			[[
function use{Hook}() {{
  const [state, setState] = React.useState({init});
  {body}
  return {{ state, setState }};
}}
  ]],
			{
				Hook = ls.insert_node(1, "Thing"),
				init = ls.insert_node(2, "null"),
				body = ls.insert_node(3, "// custom logic"),
			}
		)
	),
}
