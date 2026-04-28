local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"args",
		fmt(
			[[
const args = process.argv.slice(2);
console.log(args);
]],
			{}
		)
	),
}
