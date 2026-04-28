local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"varenc",
		fmt(
			[[
public static int WriteVarInt(Span<byte> dst, uint value)
{{
    int i = 0;
    while (value >= 0x80)
    {{
        dst[i++] = (byte)(value | 0x80);
        value >>= 7;
    }}
    dst[i++] = (byte)value;
    return i;
}}
  ]],
			{}
		)
	),
}
