local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"claimst",
		fmt(
			[[
public class AddCustomClaims : IClaimsTransformation
{{
    public Task<ClaimsPrincipal> TransformAsync(ClaimsPrincipal principal)
    {{
        var id = (ClaimsIdentity)principal.Identity!;
        if (!id.HasClaim(c => c.Type == "tier"))
            id.AddClaim(new Claim("tier", "standard"));

        return Task.FromResult(principal);
    }}
}}
  ]],
			{}
		)
	),
}
