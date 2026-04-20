local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"sockloop",
		fmt(
			[[
using var socket = new Socket(SocketType.Stream, ProtocolType.Tcp);
socket.Connect({host}, {port});

Span<byte> buf = stackalloc byte[2048];

while (true)
{{
    int read = socket.Receive(buf);
    if (read == 0) break;

    // process buf[..read]
}}
  ]],
			{
				host = ls.insert_node(1, '"localhost"'),
				port = ls.insert_node(2, "9000"),
			}
		)
	),
}
