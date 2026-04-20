local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"cbfall",
		fmt(
			[[
function cbWithFallback(fn, fallback, {fails}, {reset}) {{
  let errCount = 0;
  let open = false;
  let until = 0;

  return async (...args) => {{
    const now = Date.now();
    if (open && now < until) return fallback(...args);
    if (open && now >= until) open = false;

    try {{
      const result = await fn(...args);
      errCount = 0;
      return result;
    }} catch (err) {{
      errCount++;
      if (errCount >= fails) {{
        open = true;
        until = now + reset;
      }}
      return fallback(...args);
    }}
  }};
}}

module.exports = cbWithFallback;
  ]],
			{
				fails = ls.insert_node(1, "5"),
				reset = ls.insert_node(2, "10000"),
			}
		)
	),
}
