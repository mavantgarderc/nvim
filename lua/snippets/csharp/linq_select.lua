local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"linqselect",
		fmt(
			[[
var result = {source}.Select(x => {proj}).ToList();
  ]],
			{
				source = ls.insert_node(1, "items"),
				proj = ls.insert_node(2, "x.Name"),
			}
		)
	),
}
