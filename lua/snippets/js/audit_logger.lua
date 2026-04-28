local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"audit",
		fmt(
			[[
function audit(action) {{
  return (req, res, next) => {{
    const entry = {{
      action,
      user: req.user?.id || "guest",
      ts: Date.now(),
      path: req.path,
      method: req.method
    }};

    console.log("AUDIT:", JSON.stringify(entry));
    next();
  }};
}}

module.exports = audit;
  ]],
			{}
		)
	),
}
