local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"seqread",
		fmt(
			[[
var reader = new SequenceReader<byte>(buffer);

while (!reader.End)
{{
    if (!reader.TryRead(out byte b)) break;
    // process b

    // example: try read 4-byte big-endian int
    if (reader.TryReadBigEndian(out int val))
    {{
        // process int
    }}
}}
  ]],
			{}
		)
	),
}
