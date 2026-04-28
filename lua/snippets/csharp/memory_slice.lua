local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"memslice",
		fmt(
			[[
var mem = new Memory<int>(new int[] {{ {values} }});
var slice = mem.Slice({start}, {len});
  ]],
			{
				values = ls.insert_node(1, "1, 2, 3, 4, 5"),
				start = ls.insert_node(2, "1"),
				len = ls.insert_node(3, "3"),
			}
		)
	),
}
