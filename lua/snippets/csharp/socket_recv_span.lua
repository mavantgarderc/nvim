local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"sockrecv",
		fmt(
			[[
using var socket = new Socket(SocketType.Stream, ProtocolType.Tcp);
socket.Connect({host}, {port});

Span<byte> buffer = stackalloc byte[1024];
int received = socket.Receive(buffer);

Console.WriteLine($"Received: {received} bytes");
  ]],
			{
				host = ls.insert_node(1, '"127.0.0.1"'),
				port = ls.insert_node(2, "5000"),
			}
		)
	),
}
