local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"abac",
		fmt(
			[[
public static bool EvaluateAbac(ClaimsPrincipal user, string resource, string action)
{{
    var attrs = user.Claims
        .Where(c => c.Type.StartsWith("attr:"))
        .ToDictionary(c => c.Type[5..], c => c.Value);

    // Example: "department" must match
    return attrs.TryGetValue("department", out var dept) &&
           dept == resource;
}}
  ]],
			{}
		)
	),
}
