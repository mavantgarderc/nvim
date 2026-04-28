local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"pipereader",
		fmt(
			[[
var pipe = new Pipe();
var reader = pipe.Reader;

while (true)
{{
    var result = await reader.ReadAsync();
    var buffer = result.Buffer;

    // process buffer slices
    foreach (var s in buffer)
    {{
        // use s.Span
    }}

    reader.AdvanceTo(buffer.End);

    if (result.IsCompleted)
        break;
}}

reader.Complete();
  ]],
			{}
		)
	),
}
