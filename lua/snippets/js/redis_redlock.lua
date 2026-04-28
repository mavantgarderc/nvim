local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"redlock",
		fmt(
			[[
const { v4: uuid } = require("uuid");

async function redlock(redis, key, ttl, worker) {{
  const token = uuid();
  const acquired = await redis.set(key, token, "PX", ttl, "NX");

  if (!acquired) throw new Error("lock-failed");

  try {{
    return await worker();
  }} finally {{
    const val = await redis.get(key);
    if (val === token) await redis.del(key);
  }}
}}

module.exports = redlock;
  ]],
			{}
		)
	),
}
