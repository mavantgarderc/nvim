local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"rospanparse",
		fmt(
			[[
ReadOnlySpan<char> span = {input}.AsSpan();
int value = int.Parse(span);
  ]],
			{
				input = ls.insert_node(1, '"123"'),
			}
		)
	),
}
