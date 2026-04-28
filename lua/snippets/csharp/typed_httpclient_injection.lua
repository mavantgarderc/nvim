local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"typedclient",
		fmt(
			[[
public class {ClientName}
{{
    private readonly HttpClient _http;

    public {ClientName}(HttpClient http)
    {{
        _http = http;
    }}

    public async Task<string> GetAsync()
    {{
        return await _http.GetStringAsync("{url}");
    }}
}}

// Program.cs
builder.Services.AddHttpClient<{ClientName}>();
  ]],
			{
				ClientName = ls.insert_node(1, "MyApiClient"),
				url = ls.insert_node(2, "/endpoint"),
			}
		)
	),
}
