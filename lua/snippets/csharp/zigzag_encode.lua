local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"zigenc",
		fmt(
			[[
[MethodImpl(MethodImplOptions.AggressiveInlining)]
public static uint ZigZagEncode(int v)
    => (uint)((v << 1) ^ (v >> 31));
  ]],
			{}
		)
	),
}
