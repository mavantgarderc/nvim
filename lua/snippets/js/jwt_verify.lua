local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"jwtVerify",
		fmt(
			[[
const jwt = require("jsonwebtoken");

function verifyJwt(token, secret = process.env.JWT_SECRET) {{
  try {{
    return jwt.verify(token, secret);
  }} catch (_) {{
    return null;
  }}
}}

module.exports = verifyJwt;
  ]],
			{}
		)
	),
}
