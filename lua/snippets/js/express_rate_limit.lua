local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"erat",
		fmt(
			[[
function rateLimit(windowMs, max) {{
  const hits = new Map();
  return (req, res, next) => {{
    const ip = req.ip;
    const now = Date.now();
    const entry = hits.get(ip) || [];
    const recent = entry.filter(ts => now - ts < windowMs);

    if (recent.length >= max) {{
      return res.status(429).json({{ error: 'Too Many Requests' }});
    }}

    recent.push(now);
    hits.set(ip, recent);
    next();
  }};
}}
]],
			{}
		)
	),
}
