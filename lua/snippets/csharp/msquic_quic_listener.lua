local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"quiclisten",
		fmt(
			[[
var listener = await QuicListener.ListenAsync(new QuicListenerOptions
{{
    ListenEndPoint = new IPEndPoint(IPAddress.Any, {port}),
    ApplicationProtocols = new List<SslApplicationProtocol>
    {{
        SslApplicationProtocol.Http3
    }}
}});

while (true)
{{
    var conn = await listener.AcceptConnectionAsync();
    _ = Task.Run(async () =>
    {{
        var stream = await conn.AcceptInboundStreamAsync();
        byte[] buf = new byte[1024];
        int read = await stream.ReadAsync(buf);
    }});
}}
  ]],
			{
				port = ls.insert_node(1, "4433"),
			}
		)
	),
}
