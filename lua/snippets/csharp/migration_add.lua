local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"efadd",
		fmt(
			[[
dotnet ef migrations add {Name}
  ]],
			{
				Name = ls.insert_node(1, "InitialCreate"),
			}
		)
	),
}
