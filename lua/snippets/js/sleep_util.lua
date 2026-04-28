local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"sleep",
		fmt(
			[[
const sleep = (ms) => new Promise(resolve => setTimeout(resolve, ms));
]],
			{}
		)
	),
}
