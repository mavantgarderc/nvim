local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"linqdict",
		fmt(
			[[
var dict = {source}.ToDictionary(x => {key}, x => {val});
  ]],
			{
				source = ls.insert_node(1, "items"),
				key = ls.insert_node(2, "x.Id"),
				val = ls.insert_node(3, "x"),
			}
		)
	),
}
