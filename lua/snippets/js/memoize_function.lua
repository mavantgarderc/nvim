local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"memo",
		fmt(
			[[
function memoize(fn) {{
  const cache = new Map();
  return (...args) => {{
    const key = JSON.stringify(args);
    if (cache.has(key)) return cache.get(key);
    const result = fn(...args);
    cache.set(key, result);
    return result;
  }};
}}
]],
			{}
		)
	),
}
