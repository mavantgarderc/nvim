local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"bpress",
		fmt(
			[[
function backpressure(queue, maxQueue) {{
  return (req, res, next) => {{
    if (queue.length >= maxQueue)
      return res.status(503).json({{ error: "backpressure" }});
    queue.push({{ req, res, next }});
  }};
}}

module.exports = backpressure;
  ]],
			{}
		)
	),
}
