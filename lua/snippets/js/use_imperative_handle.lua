local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"uih",
		fmt(
			[[
React.useImperativeHandle({ref}, () => ({
  {methods}
}));
  ]],
			{
				ref = ls.insert_node(1, "ref"),
				methods = ls.insert_node(2, "// exposed functions"),
			}
		)
	),
}
