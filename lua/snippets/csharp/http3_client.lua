local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"http3",
		fmt(
			[[
var handler = new SocketsHttpHandler()
{{
    EnableMultipleHttp2Connections = true,
    AutomaticDecompression = DecompressionMethods.All,
    ConnectTimeout = TimeSpan.FromSeconds(5)
}};

// HTTP/3 enabled automatically with QUIC support
var client = new HttpClient(handler);
var resp = await client.GetAsync({url}, HttpCompletionOption.ResponseHeadersRead);
Console.WriteLine(await resp.Content.ReadAsStringAsync());
  ]],
			{
				url = ls.insert_node(1, '"https://example.com"'),
			}
		)
	),
}
