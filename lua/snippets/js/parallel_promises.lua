local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"par",
		fmt(
			[[
const [ {}, {} ] = await Promise.all([
  {},
  {}
]);
]],
			{
				i(1, "a"),
				i(2, "b"),
				i(3, "promiseA"),
				i(4, "promiseB"),
			}
		)
	),
}
