local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"rbatch",
		fmt(
			[[
public IEnumerable<T> ReadBatch(long start, int count)
{{
    for (int i = 0; i < count; i++)
    {{
        yield return _buffer[(start + i) & _mask];
    }}
}}
  ]],
			{}
		)
	),
}
