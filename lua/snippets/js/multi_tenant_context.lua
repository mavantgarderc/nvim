local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"mtctx",
		fmt(
			[[
function tenantContext(req) {{
  return req.headers["x-tenant-id"] || "default";
}}

module.exports = tenantContext;
  ]],
			{}
		)
	),
}
