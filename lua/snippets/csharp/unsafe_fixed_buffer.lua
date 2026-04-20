local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"fixedbuf",
		fmt(
			[[
unsafe struct Buffer
{{
    public fixed byte Data[{size}];
}}

var buf = new Buffer();
fixed (byte* p = buf.Data)
{{
    for (int i = 0; i < {size}; i++)
        p[i] = (byte)i;
}}
  ]],
			{
				size = ls.insert_node(1, "256"),
			}
		)
	),
}
