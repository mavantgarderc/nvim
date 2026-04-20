local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"convertall",
		fmt(
			[[
var converted = {list}.ConvertAll(x => {expr});
  ]],
			{
				list = ls.insert_node(1, "items"),
				expr = ls.insert_node(2, "x.ToString()"),
			}
		)
	),
}
