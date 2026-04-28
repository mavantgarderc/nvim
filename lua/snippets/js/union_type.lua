local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"uni",
		fmt("type {} = {} | {};", {
			i(1, "Result"),
			i(2, "A"),
			i(3, "B"),
		})
	),
}
