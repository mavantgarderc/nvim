local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"segpool",
		fmt(
			[[
int segmentSize = {size};
var segments = new List<byte[]>();

for (int i = 0; i < {count}; i++)
{{
    segments.Add(ArrayPool<byte>.Shared.Rent(segmentSize));
}}
  ]],
			{
				size = ls.insert_node(1, "8192"),
				count = ls.insert_node(2, "10"),
			}
		)
	),
}
