local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"streamwrite",
		fmt(
			[[
using var writer = new StreamWriter("{path}");
writer.WriteLine({content});
  ]],
			{
				path = ls.insert_node(1, "file.txt"),
				content = ls.insert_node(2, '"hello"'),
			}
		)
	),
}
