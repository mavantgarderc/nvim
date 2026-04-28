local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"linqsum",
		fmt(
			[[
var sum = {source}.Sum(x => {selector});
  ]],
			{
				source = ls.insert_node(1, "items"),
				selector = ls.insert_node(2, "x.Amount"),
			}
		)
	),
}
