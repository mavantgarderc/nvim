local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"bucket",
		fmt(
			[[
function tokenBucket({rate}, {burst}) {{
  let tokens = burst;
  let last = Date.now();

  return (req, res, next) => {{
    const now = Date.now();
    const delta = (now - last) / 1000;
    last = now;
    tokens = Math.min(burst, tokens + delta * rate);
    if (tokens < 1) return res.status(429).json({{ error: "rate limit" }});
    tokens -= 1;
    next();
  }};
}}

module.exports = tokenBucket;
  ]],
			{
				rate = ls.insert_node(1, "5"), -- tokens per second
				burst = ls.insert_node(2, "10"), -- bucket size
			}
		)
	),
}
