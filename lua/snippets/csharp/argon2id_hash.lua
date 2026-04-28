local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"argon2h",
		fmt(
			[[
public static string HashPassword(string password)
{{
    var salt = RandomNumberGenerator.GetBytes(16);
    var argon = new Argon2id(Encoding.UTF8.GetBytes(password))
    {{
        Salt = salt,
        DegreeOfParallelism = 4,
        MemorySize = 64_000,
        Iterations = 3
    }};

    var hash = argon.GetBytes(32);
    return Convert.ToBase64String(salt) + ":" + Convert.ToBase64String(hash);
}}
  ]],
			{}
		)
	),
}
