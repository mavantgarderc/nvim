local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"rlua",
		fmt(
			[[
const luaScript = `
local key = KEYS[1]
local limit = tonumber(ARGV[1])
local window = tonumber(ARGV[2])
local current = redis.call("INCR", key)

if current == 1 then
  redis.call("PEXPIRE", key, window)
end

if current > limit then
  return 0
else
  return 1
end
`

async function distributedRateLimit(redis, key, limit, window) {{
  const allowed = await redis.eval(luaScript, 1, key, limit, window)
  return allowed === 1
}}

module.exports = distributedRateLimit;
  ]],
			{}
		)
	),
}
