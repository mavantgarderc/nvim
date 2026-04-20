local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"fwrite",
		fmt(
			[[
public static int WriteFrame(Span<byte> dst, ReadOnlySpan<byte> payload)
{{
    BinaryPrimitives.WriteInt32BigEndian(dst, payload.Length);
    payload.CopyTo(dst.Slice(4));
    return 4 + payload.Length;
}}
  ]],
			{}
		)
	),
}
