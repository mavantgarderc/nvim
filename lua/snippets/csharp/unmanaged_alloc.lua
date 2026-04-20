local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"mallocfree",
		fmt(
			[[
nint ptr = NativeMemory.Alloc({bytes});
try
{{
    Span<byte> span = new Span<byte>((void*)ptr, {bytes});
    // use span
}}
finally
{{
    NativeMemory.Free(ptr);
}}
  ]],
			{
				bytes = ls.insert_node(1, "1024"),
			}
		)
	),
}
