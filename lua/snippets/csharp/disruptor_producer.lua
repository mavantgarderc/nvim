local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"dprod",
		fmt(
			[[
public void Publish(long seq, long value)
{{
    var slot = ref _buffer[seq & _mask];
    slot.Value = value;
    Volatile.Write(ref slot.Sequence, seq);
}}
  ]],
			{}
		)
	),
}
