local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"httpresponse",
		fmt(
			[[
var response = await {call};
if (!response.IsSuccessStatusCode)
{{
    var err = await response.Content.ReadAsStringAsync();
    throw new Exception($"HTTP {{response.StatusCode}}: {{err}}");
}}

var data = await response.Content.ReadAsStringAsync();
  ]],
			{
				call = ls.insert_node(1, "client.GetAsync(url)"),
			}
		)
	),
}
