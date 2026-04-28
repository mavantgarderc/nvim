local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"expa",
		fmt(
			[[
await expect({}).resolves.toEqual({});
]],
			{ i(1, "promise"), i(2, "{}") }
		)
	),
}
