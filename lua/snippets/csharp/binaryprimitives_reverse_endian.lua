local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"bendian",
		fmt(
			[[
ushort val = {value};
ushort swapped = BinaryPrimitives.ReverseEndianness(val);
  ]],
			{
				value = ls.insert_node(1, "0x1234"),
			}
		)
	),
}
