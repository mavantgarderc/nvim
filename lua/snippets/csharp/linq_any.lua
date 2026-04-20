local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"linqany",
		fmt(
			[[
bool exists = {source}.Any(x => {cond});
  ]],
			{
				source = ls.insert_node(1, "items"),
				cond = ls.insert_node(2, "x.IsActive"),
			}
		)
	),
}
