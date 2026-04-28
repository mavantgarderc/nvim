local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"exp",
		fmt("expect({}).toBe({});", {
			i(1, "value"),
			i(2, "expected"),
		})
	),
}
