local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"wsclient",
		fmt(
			[[
using var ws = new ClientWebSocket();
await ws.ConnectAsync(new Uri("{url}"), CancellationToken.None);

var bytes = Encoding.UTF8.GetBytes({msg});
await ws.SendAsync(bytes, WebSocketMessageType.Text, true, CancellationToken.None);

var buffer = new byte[1024];
var result = await ws.ReceiveAsync(buffer, CancellationToken.None);
var text = Encoding.UTF8.GetString(buffer, 0, result.Count);
  ]],
			{
				url = ls.insert_node(1, "wss://example.com/ws"),
				msg = ls.insert_node(2, '"hello"'),
			}
		)
	),
}
