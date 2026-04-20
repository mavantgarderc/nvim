local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"vardec",
		fmt(
			[[
public static uint ReadVarInt(ReadOnlySpan<byte> src, out int consumed)
{{
    uint result = 0;
    int shift = 0;
    consumed = 0;

    foreach (var b in src)
    {{
        uint v = (uint)(b & 0x7F);
        result |= v << shift;
        consumed++;

        if ((b & 0x80) == 0) break;

        shift += 7;
        if (shift > 35) throw new FormatException("varint overflow");
    }}

    return result;
}}
  ]],
			{}
		)
	),
}
