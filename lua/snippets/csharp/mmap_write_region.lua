local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"mmapw",
		fmt(
			[[
using var mmf = MemoryMappedFile.CreateFromFile({path}, FileMode.Open);
using var accessor = mmf.CreateViewAccessor({offset}, {length});
accessor.Write({offset2}, (byte){value});
  ]],
			{
				path = ls.insert_node(1, '"data.bin"'),
				offset = ls.insert_node(2, "0"),
				length = ls.insert_node(3, "1024"),
				offset2 = ls.insert_node(4, "10"),
				value = ls.insert_node(5, "255"),
			}
		)
	),
}
