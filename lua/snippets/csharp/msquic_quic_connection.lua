local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"quicconn",
		fmt(
			[[
var client = new QuicConnection(
    QuicImplementationProviders.MsQuic,
    new QuicClientConnectionOptions
    {{
        RemoteEndPoint = new IPEndPoint(IPAddress.Parse({host}), {port})
    }});

await client.ConnectAsync();

var stream = await client.OpenOutboundStreamAsync(QuicStreamType.Bidirectional);
await stream.WriteAsync(Encoding.UTF8.GetBytes({msg}));
  ]],
			{
				host = ls.insert_node(1, '"127.0.0.1"'),
				port = ls.insert_node(2, "4433"),
				msg = ls.insert_node(3, '"hello quic"'),
			}
		)
	),
}
