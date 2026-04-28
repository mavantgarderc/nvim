local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"simdloop",
		fmt(
			[[
Span<float> data = stackalloc float[{size}];

// Fill
for (int i = 0; i < data.Length; i++)
    data[i] = i;

// Vectorized sum
var sum = Vector<float>.Zero;
int i = 0;
for (; i <= data.Length - Vector<float>.Count; i += Vector<float>.Count)
{{
    var v = new Vector<float>(data[i..]);
    sum += v;
}}
  ]],
			{
				size = ls.insert_node(1, "1024"),
			}
		)
	),
}
