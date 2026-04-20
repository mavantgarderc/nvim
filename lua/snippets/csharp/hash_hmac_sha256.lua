local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"hmacsha256",
		fmt(
			[[
using var hmac = new HMACSHA256(Encoding.UTF8.GetBytes({key}));
var hash = hmac.ComputeHash(Encoding.UTF8.GetBytes({data}));
var hex = Convert.ToHexString(hash);
  ]],
			{
				key = ls.insert_node(1, '"secret_key"'),
				data = ls.insert_node(2, '"payload"'),
			}
		)
	),
}
