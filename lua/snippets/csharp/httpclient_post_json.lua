local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"httppostjson",
		fmt(
			[[
using var client = new HttpClient();

var json = JsonSerializer.Serialize({obj});
var content = new StringContent(json, Encoding.UTF8, "application/json");

var response = await client.PostAsync("{url}", content);
response.EnsureSuccessStatusCode();
  ]],
			{
				obj = ls.insert_node(1, "data"),
				url = ls.insert_node(2, "https://api.example.com/create"),
			}
		)
	),
}
