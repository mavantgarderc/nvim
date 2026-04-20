local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"utr",
		fmt(
			[[
const [{pending}, {start}] = React.useTransition();
  ]],
			{
				pending = ls.insert_node(1, "isPending"),
				start = ls.insert_node(2, "startTransition"),
			}
		)
	),
}
