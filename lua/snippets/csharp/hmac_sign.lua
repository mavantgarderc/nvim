local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"hmacsig",
		fmt(
			[[
public static string SignHmac(string secret, string data)
{{
    using var h = new HMACSHA256(Encoding.UTF8.GetBytes(secret));
    var sig = h.ComputeHash(Encoding.UTF8.GetBytes(data));
    return Convert.ToHexString(sig).ToLowerInvariant();
}}
  ]],
			{}
		)
	),
}
