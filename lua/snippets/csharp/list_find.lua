local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"listfind",
		fmt(
			[[
var found = {list}.Find(x => {cond});
  ]],
			{
				list = ls.insert_node(1, "items"),
				cond = ls.insert_node(2, "x.Id == id"),
			}
		)
	),
}
