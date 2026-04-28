local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"redissess",
		fmt(
			[[
public class RedisSessionStore
{{
    private readonly IDatabase _db;

    public RedisSessionStore(IConnectionMultiplexer redis)
        => _db = redis.GetDatabase();

    public Task SetAsync(string key, string json, TimeSpan ttl)
        => _db.StringSetAsync(key, json, ttl);

    public async Task<string?> GetAsync(string key)
    {{
        var v = await _db.StringGetAsync(key);
        return v.IsNull ? null : v.ToString();
    }}

    public Task DeleteAsync(string key)
        => _db.KeyDeleteAsync(key);
}}
  ]],
			{}
		)
	),
}
