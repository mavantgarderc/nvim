local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"protow",
		fmt(
			[[
public ref struct ProtoWriter
{{
    private Span<byte> _span;
    private int _idx;

    public ProtoWriter(Span<byte> span) => (_span, _idx) = (span, 0);

    public void WriteVar(uint v)
    {{
        _idx += WriteVarInt(_span.Slice(_idx), v);
    }}

    public void WriteBytes(ReadOnlySpan<byte> src)
    {{
        src.CopyTo(_span.Slice(_idx));
        _idx += src.Length;
    }}

    public int Written => _idx;
}}
  ]],
			{}
		)
	),
}
