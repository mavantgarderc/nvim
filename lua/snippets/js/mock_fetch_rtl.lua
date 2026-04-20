local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"mfetch",
		fmt(
			[[
global.fetch = vi.fn().mockResolvedValue({{
  json: async () => ({})
}});
]],
			{ i(1, "{}") }
		)
	),
}
