local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"mchain",
		fmt(
			[[
function chain(...mws) {{
  return (req, res, next) => {{
    let i = 0;
    function run() {{
      const mw = mws[i++];
      if (!mw) return next();
      mw(req, res, run);
    }}
    run();
  }};
}}
]],
			{}
		)
	),
}
