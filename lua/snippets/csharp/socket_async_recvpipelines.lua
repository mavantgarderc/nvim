local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"sockpipe",
		fmt(
			[[
var pipe = new Pipe();
var socket = new Socket(SocketType.Stream, ProtocolType.Tcp);
socket.Connect({host}, {port});

// producer
_ = Task.Run(async () =>
{{
    var writer = pipe.Writer;

    while (true)
    {{
        Memory<byte> mem = writer.GetMemory(2048);
        int read = await socket.ReceiveAsync(mem, SocketFlags.None);

        if (read == 0) break;

        writer.Advance(read);
        var f = await writer.FlushAsync();
        if (f.IsCompleted) break;
    }}

    writer.Complete();
}});

// consumer side
var reader = pipe.Reader;
while (true)
{{
    var result = await reader.ReadAsync();
    var buf = result.Buffer;

    // process buf
    reader.AdvanceTo(buf.End);

    if (result.IsCompleted) break;
}}
  ]],
			{
				host = ls.insert_node(1, '"127.0.0.1"'),
				port = ls.insert_node(2, "5050"),
			}
		)
	),
}
