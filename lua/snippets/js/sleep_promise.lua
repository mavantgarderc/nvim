local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"slp",
		fmt(
			[[
const sleep = (ms) => new Promise(res => setTimeout(res, ms));
]],
			{}
		)
	),
}
