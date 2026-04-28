local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"reh",
		fmt(
			[[
const {} = (event) => {{
  {}
}};
]],
			{ i(1, "handleEvent"), i(2) }
		)
	),
}
