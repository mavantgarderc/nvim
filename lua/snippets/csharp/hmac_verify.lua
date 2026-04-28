local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"hmacver",
		fmt(
			[[
public static bool VerifyHmac(string secret, string data, string signature)
{{
    using var h = new HMACSHA256(Encoding.UTF8.GetBytes(secret));
    var expected = h.ComputeHash(Encoding.UTF8.GetBytes(data));
    var provided = Convert.FromHexString(signature);
    return CryptographicOperations.FixedTimeEquals(expected, provided);
}}
  ]],
			{}
		)
	),
}
