local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"rbac",
		fmt(
			[[
public static bool HasRole(ClaimsPrincipal user, string role)
    => user.Claims.Any(c => c.Type == ClaimTypes.Role && c.Value == role);
  ]],
			{}
		)
	),
}
