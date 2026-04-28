local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"ticketenc",
		fmt(
			[[
public static byte[] EncryptTicket(string json, byte[] key)
{{
    using var aes = Aes.Create();
    aes.Key = key;
    aes.GenerateIV();

    using var enc = aes.CreateEncryptor();
    var payload = enc.TransformFinalBlock(Encoding.UTF8.GetBytes(json), 0, json.Length);

    var result = new byte[aes.IV.Length + payload.Length];
    aes.IV.CopyTo(result, 0);
    payload.CopyTo(result, aes.IV.Length);
    return result;
}}
  ]],
			{}
		)
	),
}
