local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"pt",
		fmt(
			[[
const timeout = (ms) =>
  new Promise((_, reject) => setTimeout(() => reject(new Error('Timeout')), ms));
]],
			{}
		)
	),
}
