local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"rtli",
		fmt(
			[[
import {{ render, screen }} from '@testing-library/react';
import userEvent from '@testing-library/user-event';
]],
			{}
		)
	),
}
