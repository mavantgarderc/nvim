local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"rsasign",
		fmt(
			[[
using var rsa = RSA.Create();
rsa.ImportRSAPrivateKey({priv}, out _);

var data = Encoding.UTF8.GetBytes({text});
var signature = rsa.SignData(data, HashAlgorithmName.SHA256, RSASignaturePadding.Pkcs1);

// Verify
rsa.ImportRSAPublicKey({pub}, out _);
bool ok = rsa.VerifyData(data, signature, HashAlgorithmName.SHA256, RSASignaturePadding.Pkcs1);
  ]],
			{
				priv = ls.insert_node(1, "privateKey"),
				pub = ls.insert_node(2, "publicKey"),
				text = ls.insert_node(3, '"hello"'),
			}
		)
	),
}
