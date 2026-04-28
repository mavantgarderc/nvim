local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"jwtgen",
		fmt(
			[[
public static string CreateJwt(string issuer, string audience, string key, IEnumerable<Claim> claims, int minutes)
{{
    var creds = new SigningCredentials(
        new SymmetricSecurityKey(Encoding.UTF8.GetBytes(key)),
        SecurityAlgorithms.HmacSha256);

    var token = new JwtSecurityToken(
        issuer,
        audience,
        claims,
        expires: DateTime.UtcNow.AddMinutes(minutes),
        signingCredentials: creds);

    return new JwtSecurityTokenHandler().WriteToken(token);
}}
  ]],
			{}
		)
	),
}
