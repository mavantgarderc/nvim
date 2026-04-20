local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"afi",
		fmt("const {} = ({}) => {};", {
			i(1, "func"),
			i(2),
			i(3, "value"),
		})
	),
}
