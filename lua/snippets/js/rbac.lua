local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"rbac",
		fmt(
			[[
function createRBAC(rules) {{
  return function hasAccess(role, action) {{
    const allowed = rules[role] || [];
    return allowed.includes(action);
  }};
}}

module.exports = createRBAC;
  ]],
			{}
		)
	),
}
