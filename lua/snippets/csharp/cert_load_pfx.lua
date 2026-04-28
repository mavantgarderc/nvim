local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"certpfx",
		fmt(
			[[
var cert = new X509Certificate2({path}, {password}, X509KeyStorageFlags.EphemeralKeySet);
  ]],
			{
				path = ls.insert_node(1, '"mycert.pfx"'),
				password = ls.insert_node(2, '"password123"'),
			}
		)
	),
}
