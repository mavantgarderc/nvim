local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"npserver",
		fmt(
			[[
var pipe = new NamedPipeServerStream({name}, PipeDirection.InOut,
    1, PipeTransmissionMode.Byte, PipeOptions.Asynchronous);

await pipe.WaitForConnectionAsync();

var reader = PipeReader.Create(pipe);
var writer = PipeWriter.Create(pipe);

while (true)
{{
    var result = await reader.ReadAsync();
    var buffer = result.Buffer;

    // process buffer
    reader.AdvanceTo(buffer.End);

    if (result.IsCompleted) break;
}}
  ]],
			{
				name = ls.insert_node(1, '"mava_pipe"'),
			}
		)
	),
}
