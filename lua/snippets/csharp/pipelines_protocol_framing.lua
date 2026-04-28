local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"pipeframe",
		fmt(
			[[
async Task ReadFramesAsync(PipeReader reader)
{{
    while (true)
    {{
        var result = await reader.ReadAsync();
        var buffer = result.Buffer;

        while (TryReadFrame(ref buffer, out var frame))
        {{
            // process frame
        }}

        reader.AdvanceTo(buffer.Start, buffer.End);

        if (result.IsCompleted) break;
    }}
}

bool TryReadFrame(ref ReadOnlySequence<byte> buffer, out ReadOnlySequence<byte> payload)
{{
    payload = default;

    if (buffer.Length < 4) return false;

    int len = BitConverter.ToInt32(buffer.Slice(0, 4).ToArray());
    if (buffer.Length < 4 + len) return false;

    payload = buffer.Slice(4, len);
    buffer = buffer.Slice(4 + len);
    return true;
}}
  ]],
			{}
		)
	),
}
