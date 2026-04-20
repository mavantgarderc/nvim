local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"pipewriter",
		fmt(
			[[
var pipe = new Pipe();
var writer = pipe.Writer;

await using (var stream = {stream})
{{
    while (true)
    {{
        Memory<byte> mem = writer.GetMemory(512);
        int read = await stream.ReadAsync(mem);

        if (read == 0)
            break;

        writer.Advance(read);

        var result = await writer.FlushAsync();
        if (result.IsCompleted)
            break;
    }}

    writer.Complete();
}}
  ]],
			{
				stream = ls.insert_node(1, 'File.OpenRead("input.bin")'),
			}
		)
	),
}
