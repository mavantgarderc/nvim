local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"spansplit",
		fmt(
			[[
ReadOnlySpan<char> span = {text}.AsSpan();
int idx = span.IndexOf({sep});
var left = span[..idx];
var right = span[(idx + 1)..];
  ]],
			{
				text = ls.insert_node(1, '"key:value"'),
				sep = ls.insert_node(2, "':'"),
			}
		)
	),
}
