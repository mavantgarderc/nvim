local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"tcplistener",
		fmt(
			[[
var listener = new TcpListener(IPAddress.Any, {port});
listener.Start();

while (true)
{{
    var client = await listener.AcceptTcpClientAsync();
    _ = Task.Run(async () =>
    {{
        using var stream = client.GetStream();
        var reader = new StreamReader(stream);
        var writer = new StreamWriter(stream) {{ AutoFlush = true }};

        var line = await reader.ReadLineAsync();
        await writer.WriteLineAsync($"echo: {{line}}");
    }});
}}
  ]],
			{
				port = ls.insert_node(1, "9000"),
			}
		)
	),
}
