local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"shmread",
		fmt(
			[[
using var mmf = MemoryMappedFile.OpenExisting({name});
using var accessor = mmf.CreateViewAccessor();

byte[] buf = new byte[{size}];
accessor.ReadArray(0, buf, 0, buf.Length);

Console.WriteLine(Encoding.UTF8.GetString(buf));
  ]],
			{
				name = ls.insert_node(1, '"mava_shm"'),
				size = ls.insert_node(2, "4096"),
			}
		)
	),
}
