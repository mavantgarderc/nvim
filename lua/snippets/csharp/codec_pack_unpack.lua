local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"codec",
		fmt(
			[[
public static int EncodeHeader(Span<byte> dst, ushort type, uint flags, uint len)
{{
    BinaryPrimitives.WriteUInt16BigEndian(dst, type);
    BinaryPrimitives.WriteUInt32BigEndian(dst.Slice(2), flags);
    BinaryPrimitives.WriteUInt32BigEndian(dst.Slice(6), len);
    return 10;
}}

public static void DecodeHeader(ReadOnlySpan<byte> src, out ushort type, out uint flags, out uint len)
{{
    type = BinaryPrimitives.ReadUInt16BigEndian(src);
    flags = BinaryPrimitives.ReadUInt32BigEndian(src.Slice(2));
    len = BinaryPrimitives.ReadUInt32BigEndian(src.Slice(6));
}}
  ]],
			{}
		)
	),
}
