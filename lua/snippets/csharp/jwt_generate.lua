local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"jwtgen",
		fmt(
			[[
var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes({secret}));
var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

var token = new JwtSecurityToken(
    issuer: {issuer},
    audience: {audience},
    claims: new[] {{ new Claim("sub", {subject}) }},
    expires = DateTime.UtcNow.AddHours(1),
    signingCredentials: creds);

var jwt = new JwtSecurityTokenHandler().WriteToken(token);
  ]],
			{
				secret = ls.insert_node(1, '"super-secret-key"'),
				issuer = ls.insert_node(2, '"myapp"'),
				audience = ls.insert_node(3, '"myapp-users"'),
				subject = ls.insert_node(4, '"mava"'),
			}
		)
	),
}
