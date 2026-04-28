local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"rhook",
		fmt(
			[[
import {{ renderHook, act }} from '@testing-library/react';

const {{ result }} = renderHook(() => {}());
]],
			{ i(1, "useHook") }
		)
	),
}
