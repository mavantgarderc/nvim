local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"regexsg",
		fmt(
			[[
[GeneratedRegex({pattern}, RegexOptions.Compiled)]
private static partial Regex MyRegex();

var m = MyRegex().Match({input});
  ]],
			{
				pattern = ls.insert_node(1, '"^[a-zA-Z0-9_]+$"'),
				input = ls.insert_node(2, '"mava_2026"'),
			}
		)
	),
}
