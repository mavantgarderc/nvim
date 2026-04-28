local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"jwtSign",
		fmt(
			[[
const jwt = require("jsonwebtoken");

function signJwt(payload, secret = process.env.JWT_SECRET, opts = {{ expiresIn: "{exp}" }}) {{
  return jwt.sign(payload, secret, opts);
}}

module.exports = signJwt;
  ]],
			{
				exp = ls.insert_node(1, "15m"),
			}
		)
	),
}
