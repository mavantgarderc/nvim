local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"refreshRotate",
		fmt(
			[[
const {{ v4: uuid }} = require("uuid");

async function rotateRefresh(redis, userId, ttl = {ttl}) {{
  const tokenId = uuid();
  const key = `refresh:${{userId}}`;

  await redis.set(key, tokenId, "EX", ttl);

  return tokenId;
}}

async function validateRefresh(redis, userId, tokenId) {{
  const key = `refresh:${{userId}}`;
  const stored = await redis.get(key);
  return stored === tokenId;
}}

module.exports = {{ rotateRefresh, validateRefresh }};
  ]],
			{
				ttl = ls.insert_node(1, "604800"), -- 7 days
			}
		)
	),
}
