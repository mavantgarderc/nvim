local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"seqreader",
		fmt(
			[[
var bytes = new byte[] {{ {data} }};
var seq = new ReadOnlySequence<byte>(bytes);
var reader = new SequenceReader<byte>(seq);

reader.TryRead(out byte first);
reader.TryReadBigEndian(out int val);
  ]],
			{
				data = ls.insert_node(1, "1,0,0,0,42"),
			}
		)
	),
}
