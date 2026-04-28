local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"dslot",
		fmt(
			[[
[StructLayout(LayoutKind.Explicit, Size = 128)]
public struct Slot
{{
    [FieldOffset(0)]
    public long Sequence;

    [FieldOffset(8)]
    public long Value;
}}
  ]],
			{}
		)
	),
}
