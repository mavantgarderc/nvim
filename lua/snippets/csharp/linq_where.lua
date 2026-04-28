local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"linqwhere",
		fmt(
			[[
var result = {source}.Where(x => {cond}).ToList();
  ]],
			{
				source = ls.insert_node(1, "items"),
				cond = ls.insert_node(2, "x.IsActive"),
			}
		)
	),
}
