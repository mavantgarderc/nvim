local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"spanbsearch",
		fmt(
			[[
Span<int> span = stackalloc int[] {{ {values} }};
span.Sort();
int idx = span.BinarySearch({target});
  ]],
			{
				values = ls.insert_node(1, "10, 3, 7, 1"),
				target = ls.insert_node(2, "7"),
			}
		)
	),
}
