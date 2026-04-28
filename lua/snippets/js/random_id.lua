local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"rid",
		fmt(
			[[
const id = Math.random().toString(36).slice(2);
]],
			{}
		)
	),
}
