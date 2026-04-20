local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"mmap",
		fmt(
			[[
using var mmf = MemoryMappedFile.CreateFromFile({path});
using var accessor = mmf.CreateViewAccessor();
byte value = accessor.ReadByte({offset});
  ]],
			{
				path = ls.insert_node(1, '"data.bin"'),
				offset = ls.insert_node(2, "0"),
			}
		)
	),
}
