local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"mpool",
		fmt(
			[[
using var owner = MemoryPool<byte>.Shared.Rent({size});
Memory<byte> mem = owner.Memory;

// use mem here
  ]],
			{
				size = ls.insert_node(1, "1024"),
			}
		)
	),
}
