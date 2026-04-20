local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"httprequestmsg",
		fmt(
			[[
using var client = new HttpClient();

using var request = new HttpRequestMessage(HttpMethod.{method}, "{url}")
{{
    Content = new StringContent({body}, Encoding.UTF8, "application/json")
}};

var response = await client.SendAsync(request);
response.EnsureSuccessStatusCode();

var content = await response.Content.ReadAsStringAsync();
  ]],
			{
				method = ls.insert_node(1, "Post"),
				url = ls.insert_node(2, "https://api.example.com"),
				body = ls.insert_node(3, '"{}"'),
			}
		)
	),
}
