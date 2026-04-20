local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"pbkdf2",
		fmt(
			[[
public static byte[] DerivePbkdf2(string password, byte[] salt, int bytes = 32)
{{
    using var pbkdf2 = new Rfc2898DeriveBytes(password, salt, 100_000, HashAlgorithmName.SHA256);
    return pbkdf2.GetBytes(bytes);
}}
  ]],
			{}
		)
	),
}
