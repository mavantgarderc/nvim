local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"randbytes",
		fmt(
			[[
var bytes = RandomNumberGenerator.GetBytes({len}); // cryptographically strong
  ]],
			{
				len = ls.insert_node(1, "32"),
			}
		)
	),
}
