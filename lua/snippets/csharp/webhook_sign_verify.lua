local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"whsig",
		fmt(
			[[
public static bool VerifyWebhook(string secret, string payload, string signature)
{{
    using var h = new HMACSHA256(Encoding.UTF8.GetBytes(secret));
    var hash = h.ComputeHash(Encoding.UTF8.GetBytes(payload));
    var provided = Convert.FromHexString(signature);
    return CryptographicOperations.FixedTimeEquals(hash, provided);
}}
  ]],
			{}
		)
	),
}
