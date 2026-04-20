local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"protor",
		fmt(
			[[
public ref struct ProtoReader
{{
    private ReadOnlySpan<byte> _src;
    private int _idx;

    public ProtoReader(ReadOnlySpan<byte> src)
    {{
        _src = src;
        _idx = 0;
    }}

    public uint ReadVar()
    {{
        var val = ReadVarInt(_src.Slice(_idx), out int consumed);
        _idx += consumed;
        return val;
    }}

    public ReadOnlySpan<byte> ReadBytes(int len)
    {{
        var s = _src.Slice(_idx, len);
        _idx += len;
        return s;
    }}
}}
  ]],
			{}
		)
	),
}
