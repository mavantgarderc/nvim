local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"aesenc",
		fmt(
			[[
using var aes = Aes.Create();
aes.Key = Encoding.UTF8.GetBytes({key});
aes.IV = Encoding.UTF8.GetBytes({iv});

// Encrypt
using var enc = aes.CreateEncryptor();
var cipher = enc.TransformFinalBlock(Encoding.UTF8.GetBytes({plain}), 0, {plain}.Length);

// Decrypt
using var dec = aes.CreateDecryptor();
var plainBytes = dec.TransformFinalBlock(cipher, 0, cipher.Length);
var text = Encoding.UTF8.GetString(plainBytes);
  ]],
			{
				key = ls.insert_node(1, "new string('A', 32)"),
				iv = ls.insert_node(2, "new string('B', 16)"),
				plain = ls.insert_node(3, '"hello"'),
			}
		)
	),
}
