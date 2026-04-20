local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"spanarr",
		fmt(
			[[
var arr = new int[] {{ {values} }};
Span<int> span = arr.AsSpan();

for (var i = 0; i < span.Length; i++)
{{
    span[i] *= 2;
}}
  ]],
			{
				values = ls.insert_node(1, "1, 2, 3"),
			}
		)
	),
}
