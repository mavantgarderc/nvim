local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"argon2v",
		fmt(
			[[
public static bool VerifyPassword(string password, string stored)
{{
    var parts = stored.Split(':');
    var salt = Convert.FromBase64String(parts[0]);
    var expected = Convert.FromBase64String(parts[1]);

    var argon = new Argon2id(Encoding.UTF8.GetBytes(password))
    {{
        Salt = salt,
        DegreeOfParallelism = 4,
        MemorySize = 64_000,
        Iterations = 3
    }};

    var actual = argon.GetBytes(32);
    return CryptographicOperations.FixedTimeEquals(actual, expected);
}}
  ]],
			{}
		)
	),
}
