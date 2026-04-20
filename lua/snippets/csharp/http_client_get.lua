local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"httpget",
		fmt(
			[[
using var client = new HttpClient();
var response = await client.GetAsync("{url}");
response.EnsureSuccessStatusCode();

var content = await response.Content.ReadAsStringAsync();
  ]],
			{
				url = ls.insert_node(1, "https://api.example.com"),
			}
		)
	),
}
