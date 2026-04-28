local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"sectok",
		fmt(
			[[
public static string GenerateToken(int bytes = 32)
{{
    var buf = RandomNumberGenerator.GetBytes(bytes);
    return Convert.ToHexString(buf).ToLowerInvariant();
}}
  ]],
			{}
		)
	),
}
