local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"tcpclient",
		fmt(
			[[
using var client = new TcpClient();
await client.ConnectAsync("{host}", {port});

using var stream = client.GetStream();
var writer = new StreamWriter(stream) {{ AutoFlush = true }};
var reader = new StreamReader(stream);

await writer.WriteLineAsync({msg});
var response = await reader.ReadLineAsync();
  ]],
			{
				host = ls.insert_node(1, "localhost"),
				port = ls.insert_node(2, "9000"),
				msg = ls.insert_node(3, '"hello"'),
			}
		)
	),
}
