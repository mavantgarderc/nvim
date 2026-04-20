local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"sha256",
		fmt(
			[[
using var sha = SHA256.Create();
var bytes = Encoding.UTF8.GetBytes({input});
var hash = sha.ComputeHash(bytes);
var hex = Convert.ToHexString(hash);
  ]],
			{
				input = ls.insert_node(1, '"hello"'),
			}
		)
	),
}
