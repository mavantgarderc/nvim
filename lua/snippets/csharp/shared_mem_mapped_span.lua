local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"mmapspan",
		fmt(
			[[
using var mmf = MemoryMappedFile.OpenExisting({name});
using var view = mmf.CreateViewAccessor();

view.SafeMemoryMappedViewHandle.AcquirePointer(ref *(byte**)0);
byte* ptr = null;
try
{{
    ptr = view.SafeMemoryMappedViewHandle.AcquirePointer(ref ptr);
    Span<byte> span = new(ptr, (int)view.Capacity);
    // span[..] available
}}
finally
{{
    if (ptr != null)
        view.SafeMemoryMappedViewHandle.ReleasePointer();
}}
  ]],
			{
				name = ls.insert_node(1, '"mava_shm"'),
			}
		)
	),
}
