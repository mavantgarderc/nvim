local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"ticketdec",
		fmt(
			[[
public static string DecryptTicket(byte[] data, byte[] key)
{{
    using var aes = Aes.Create();
    aes.Key = key;

    var iv = data.AsSpan(0, aes.BlockSize / 8).ToArray();
    var cipher = data.AsSpan(iv.Length).ToArray();

    aes.IV = iv;
    using var dec = aes.CreateDecryptor();
    var plain = dec.TransformFinalBlock(cipher, 0, cipher.Length);
    return Encoding.UTF8.GetString(plain);
}}
  ]],
			{}
		)
	),
}
