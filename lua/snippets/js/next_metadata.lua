local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"nmeta",
		fmt(
			[[
export const metadata = {{
  title: '{}',
  description: '{}',
}};
]],
			{ i(1, "Title"), i(2, "Description") }
		)
	),
}
