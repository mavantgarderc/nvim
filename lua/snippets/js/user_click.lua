local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"ucl",
		fmt(
			[[
await userEvent.click({});
]],
			{ i(1, "element") }
		)
	),
}
