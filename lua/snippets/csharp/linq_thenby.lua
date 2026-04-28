local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"linqthen",
		fmt(
			[[
var result = {source}
    .OrderBy(x => {key1})
    .ThenBy(x => {key2})
    .ToList();
  ]],
			{
				source = ls.insert_node(1, "items"),
				key1 = ls.insert_node(2, "x.LastName"),
				key2 = ls.insert_node(3, "x.FirstName"),
			}
		)
	),
}
