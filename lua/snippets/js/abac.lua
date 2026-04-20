local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"abac",
		fmt(
			[[
function createABAC(rules) {{
  return function can(user, resource, action) {{
    const evals = rules[action] || [];
    return evals.every(fn => fn(user, resource));
  }};
}}

module.exports = createABAC;
  ]],
			{}
		)
	),
}
