local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"binstruct",
		fmt(
			[[
public readonly struct {stype}
{{
    public readonly int A;
    public readonly long B;
}}

var s = new {stype}(1, 99);

Span<byte> buffer = stackalloc byte[Unsafe.SizeOf<{stype}>()];
MemoryMarshal.Write(buffer, ref s);

await stream.WriteAsync(buffer);
  ]],
			{
				stype = ls.insert_node(1, "MyStruct"),
			}
		)
	),
}
