local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"nrtr",
		fmt(
			[[
'use client';
import {{ useRouter }} from 'next/navigation';

const router = useRouter();
router.push('{}');
]],
			{ i(1, "/path") }
		)
	),
}
