local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"spanhex",
		fmt(
			[[
Span<byte> data = stackalloc byte[] {{ {bytes} }};
Span<char> hex = stackalloc char[data.Length * 2];
Convert.ToHexString(data, hex);
string result = hex.ToString();
  ]],
			{
				bytes = ls.insert_node(1, "1, 2, 3, 4"),
			}
		)
	),
}
