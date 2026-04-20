local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"jwtval",
		fmt(
			[[
var handler = new JwtSecurityTokenHandler();
var parameters = new TokenValidationParameters
{{
    ValidateIssuer = true,
    ValidateAudience = true,
    ValidateLifetime = true,
    ValidateIssuerSigningKey = true,
    ValidIssuer = {issuer},
    ValidAudience = {audience},
    IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes({secret}))
}};

var principal = handler.ValidateToken({token}, parameters, out var validatedToken);
  ]],
			{
				issuer = ls.insert_node(1, '"myapp"'),
				audience = ls.insert_node(2, '"myapp-users"'),
				secret = ls.insert_node(3, '"super-secret-key"'),
				token = ls.insert_node(4, "jwt"),
			}
		)
	),
}
