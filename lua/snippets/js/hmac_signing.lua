local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"hmac",
		fmt(
			[[
const crypto = require("crypto");

function hmacSign(secret, payload) {{
  return crypto
    .createHmac("sha256", secret)
    .update(payload)
    .digest("hex");
}}

module.exports = hmacSign;
  ]],
			{}
		)
	),
}
