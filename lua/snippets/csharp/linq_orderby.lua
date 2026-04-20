local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"linqorderby",
		fmt(
			[[
var result = {source}.OrderBy(x => {key}).ToList();
  ]],
			{
				source = ls.insert_node(1, "items"),
				key = ls.insert_node(2, "x.Name"),
			}
		)
	),
}
