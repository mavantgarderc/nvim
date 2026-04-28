local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"mtimer",
		fmt(
			[[
function measure(req, res, next) {{
  const start = Date.now();
  res.on('finish', () => {{
    console.log(`${{req.method}} ${{req.url}} took ${{Date.now() - start}}ms`);
  }});
  next();
}}
]],
			{}
		)
	),
}
