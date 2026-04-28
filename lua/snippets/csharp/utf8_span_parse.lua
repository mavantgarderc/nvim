local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"utf8span",
		fmt(
			[[
ReadOnlySpan<byte> utf8 = Encoding.UTF8.GetBytes({text});
string decoded = Encoding.UTF8.GetString(utf8);
  ]],
			{
				text = ls.insert_node(1, '"hello mava"'),
			}
		)
	),
}
