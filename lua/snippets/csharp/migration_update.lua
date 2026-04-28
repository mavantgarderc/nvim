local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"efup",
		fmt(
			[[
dotnet ef database update
  ]],
			{}
		)
	),
}
