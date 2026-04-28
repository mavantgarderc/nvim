local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"stackallocspan",
		fmt(
			[[
Span<byte> buffer = stackalloc byte[{size}];
for (int i = 0; i < buffer.Length; i++)
{{
    buffer[i] = (byte)i;
}}
  ]],
			{
				size = ls.insert_node(1, "128"),
			}
		)
	),
}
