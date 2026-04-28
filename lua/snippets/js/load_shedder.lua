local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"shed",
		fmt(
			[[
function loadShedding(maxInFlight) {{
  let inFlight = 0;

  return async (req, res, next) => {{
    if (inFlight >= maxInFlight) {{
      return res.status(503).json({{ error: "overloaded" }});
    }}
    inFlight++;
    try {{ await next(); }} finally {{ inFlight--; }}
  }};
}}

module.exports = loadShedding;
  ]],
			{}
		)
	),
}
