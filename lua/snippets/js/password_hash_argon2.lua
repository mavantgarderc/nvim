local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"argon2",
		fmt(
			[[
const argon2 = require("argon2");

async function hashPassword(raw) {{
  return argon2.hash(raw, {{
    type: argon2.argon2id,
    memoryCost: 2 ** 16,
    timeCost: 3,
    parallelism: 1
  }});
}}

async function verifyPassword(hash, raw) {{
  return argon2.verify(hash, raw);
}}

module.exports = {{ hashPassword, verifyPassword }};
  ]],
			{}
		)
	),
}
