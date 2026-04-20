local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"pj",
		fmt("const {} = path.join({}, '{}');", {
			i(1, "result"),
			i(2, "__dirname"),
			i(3, "folder"),
		})
	),
}
