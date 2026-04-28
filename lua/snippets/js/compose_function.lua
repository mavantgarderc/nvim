local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"compose",
		fmt(
			[[
const compose = (...fns) => (input) =>
  fns.reduceRight((acc, fn) => fn(acc), input);
]],
			{}
		)
	),
}
