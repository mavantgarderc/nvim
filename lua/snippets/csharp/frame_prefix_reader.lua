local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"fread",
		fmt(
			[[
public static bool TryReadFrame(ReadOnlySpan<byte> src, out ReadOnlySpan<byte> frame, out int consumed)
{{
    frame = default;
    consumed = 0;

    if (src.Length < 4) return false;

    int len = BinaryPrimitives.ReadInt32BigEndian(src);
    if (src.Length < 4 + len) return false;

    frame = src.Slice(4, len);
    consumed = 4 + len;
    return true;
}}
  ]],
			{}
		)
	),
}
