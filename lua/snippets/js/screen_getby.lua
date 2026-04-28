local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"gby",
		fmt("screen.getBy{}('{}')", {
			i(1, "Role"),
			i(2, "button"),
		})
	),
}
