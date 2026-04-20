local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"oauthclient",
		fmt(
			[[
public static HttpClient CreateOAuthClient(string token)
{{
    var http = new HttpClient();
    http.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);
    return http;
}}
  ]],
			{}
		)
	),
}
