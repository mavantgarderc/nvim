local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"ibw",
		fmt(
			[[
var writer = new ArrayBufferWriter<byte>();

Span<byte> span = writer.GetSpan({size});
Encoding.UTF8.GetBytes({text}, span);
writer.Advance({adv});
  ]],
			{
				size = ls.insert_node(1, "64"),
				text = ls.insert_node(2, '"hello mava"'),
				adv = ls.insert_node(3, "11"),
			}
		)
	),
}
