local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"dcons",
		fmt(
			[[
public void Consume()
{{
    long nextSeq = 0;

    while (true)
    {{
        ref var slot = ref _buffer[nextSeq & _mask];

        while (Volatile.Read(ref slot.Sequence) != nextSeq)
        {{
            Thread.SpinWait(1);
        }}

        var v = slot.Value;
        // process v

        nextSeq++;
    }}
}}
  ]],
			{}
		)
	),
}
