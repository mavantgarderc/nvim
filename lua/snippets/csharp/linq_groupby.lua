local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"linqgroup",
		fmt(
			[[
var result = {source}
    .GroupBy(x => {key})
    .Select(g => new {{
        Key = g.Key,
        Items = g.ToList()
    }})
    .ToList();
  ]],
			{
				source = ls.insert_node(1, "items"),
				key = ls.insert_node(2, "x.Category"),
			}
		)
	),
}
