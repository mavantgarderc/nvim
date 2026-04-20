local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"lru",
		fmt(
			[[
class LRU {{
  constructor(limit = {limit}) {{
    this.limit = limit;
    this.cache = new Map();
  }}

  get(key) {{
    if (!this.cache.has(key)) return null;
    const val = this.cache.get(key);
    this.cache.delete(key);
    this.cache.set(key, val);
    return val;
  }}

  set(key, val) {{
    if (this.cache.has(key)) this.cache.delete(key);
    this.cache.set(key, val);
    if (this.cache.size > this.limit) {{
      const first = this.cache.keys().next().value;
      this.cache.delete(first);
    }}
  }}
}}

module.exports = LRU;
  ]],
			{
				limit = ls.insert_node(1, "2000"),
			}
		)
	),
}
