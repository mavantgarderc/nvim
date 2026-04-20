local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"mpoolloop",
		fmt(
			[[
using var owner = MemoryPool<byte>.Shared.Rent({size});
var mem = owner.Memory;
var span = mem.Span;

for (int i = 0; i < span.Length; i++)
    span[i] = (byte)i;
  ]],
			{
				size = ls.insert_node(1, "2048"),
			}
		)
	),
}
