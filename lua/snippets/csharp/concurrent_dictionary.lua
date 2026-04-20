local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"concdict",
		fmt(
			[[
var dict = new ConcurrentDictionary<{K}, {V}>();
dict.AddOrUpdate({key}, {addVal}, (k, v) => {updateVal});
  ]],
			{
				K = ls.insert_node(1, "string"),
				V = ls.insert_node(2, "int"),
				key = ls.insert_node(3, '"k"'),
				addVal = ls.insert_node(4, "1"),
				updateVal = ls.insert_node(5, "v + 1"),
			}
		)
	),
}
