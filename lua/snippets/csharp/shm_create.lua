local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"shmcreate",
		fmt(
			[[
using var mmf = MemoryMappedFile.CreateNew({name}, {size});
using var accessor = mmf.CreateViewAccessor();

byte[] data = Encoding.UTF8.GetBytes({text});
accessor.WriteArray(0, data, 0, data.Length);
  ]],
			{
				name = ls.insert_node(1, '"mava_shm"'),
				size = ls.insert_node(2, "4096"),
				text = ls.insert_node(3, '"hello shared memory"'),
			}
		)
	),
}
