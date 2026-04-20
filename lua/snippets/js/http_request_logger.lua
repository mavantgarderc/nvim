local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"httplog",
		fmt(
			[[
function requestLogger(logger) {{
  return (req, res, next) => {{
    const start = Date.now();
    res.on("finish", () => {{
      logger.info({{
        method: req.method,
        path: req.originalUrl,
        status: res.statusCode,
        duration: Date.now() - start
      }});
    }});
    next();
  }};
}}

module.exports = requestLogger;
  ]],
			{}
		)
	),
}
