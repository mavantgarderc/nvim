local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"zigdec",
		fmt(
			[[
[MethodImpl(MethodImplOptions.AggressiveInlining)]
public static int ZigZagDecode(uint v)
    => (int)((v >> 1) ^ -(int)(v & 1));
  ]],
			{}
		)
	),
}
