local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"certpem",
		fmt(
			[[
var priv = File.ReadAllText({keyPath});
var pub = File.ReadAllText({certPath});

using var rsa = RSA.Create();
rsa.ImportFromPem(priv);

var cert = X509Certificate2.CreateFromPem(pub, priv);
  ]],
			{
				keyPath = ls.insert_node(1, '"key.pem"'),
				certPath = ls.insert_node(2, '"cert.pem"'),
			}
		)
	),
}
