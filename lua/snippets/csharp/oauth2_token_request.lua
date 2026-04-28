local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"oauthreq",
		fmt(
			[[
public static async Task<string> GetOAuthTokenAsync(HttpClient http, string tokenUrl, string clientId, string clientSecret)
{{
    var dict = new Dictionary<string,string>
    {{
        ["grant_type"] = "client_credentials",
        ["client_id"] = clientId,
        ["client_secret"] = clientSecret
    }};

    using var content = new FormUrlEncodedContent(dict);
    var res = await http.PostAsync(tokenUrl, content);
    res.EnsureSuccessStatusCode();

    var json = await res.Content.ReadAsStringAsync();
    var doc = JsonDocument.Parse(json);
    return doc.RootElement.GetProperty("access_token").GetString()!;
}}
  ]],
			{}
		)
	),
}
