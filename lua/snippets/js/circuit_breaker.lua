local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"cbreak",
		fmt(
			[[
function circuitBreaker(fn, {failLimit}, {resetTime}) {{
  let fails = 0;
  let state = "CLOSED";
  let nextTry = 0;

  return async (...args) => {{
    const now = Date.now();

    if (state === "OPEN") {{
      if (now < nextTry) throw new Error("circuit-open");
      state = "HALF";
    }}

    try {{
      const res = await fn(...args);
      fails = 0;
      state = "CLOSED";
      return res;
    }} catch (err) {{
      fails++;
      if (fails >= failLimit) {{
        state = "OPEN";
        nextTry = Date.now() + resetTime;
      }}
      throw err;
    }}
  }};
}}

module.exports = circuitBreaker;
  ]],
			{
				failLimit = ls.insert_node(1, "5"),
				resetTime = ls.insert_node(2, "10000"),
			}
		)
	),
}
