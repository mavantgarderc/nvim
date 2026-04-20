local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"socksend",
		fmt(
			[[
using var socket = new Socket(SocketType.Stream, ProtocolType.Tcp);
socket.Connect({host}, {port});

ReadOnlySpan<byte> data = Encoding.UTF8.GetBytes({msg});
socket.Send(data);
  ]],
			{
				host = ls.insert_node(1, '"127.0.0.1"'),
				port = ls.insert_node(2, "5000"),
				msg = ls.insert_node(3, '"hello Mava"'),
			}
		)
	),
}
