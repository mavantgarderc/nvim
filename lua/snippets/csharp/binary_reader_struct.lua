local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"binread",
		fmt(
			[[
Span<byte> buf = stackalloc byte[Unsafe.SizeOf<{stype}>()];
await stream.ReadExactlyAsync(buf);

{stype} value = MemoryMarshal.Read<{stype}>(buf);
  ]],
			{
				stype = ls.insert_node(1, "MyStruct"),
			}
		)
	),
}
