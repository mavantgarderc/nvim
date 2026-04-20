local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"rcache",
		fmt(
			[[
const Redis = require("ioredis");
const redis = new Redis();

async function getOrSet(key, ttl, resolver) {{
  const cached = await redis.get(key);
  if (cached) return JSON.parse(cached);

  const value = await resolver();
  await redis.set(key, JSON.stringify(value), "EX", ttl);
  return value;
}}

module.exports = {{ redis, getOrSet }};
  ]],
			{}
		)
	),
}
