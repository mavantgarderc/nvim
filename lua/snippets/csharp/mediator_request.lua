local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"mreq",
		fmt(
			[[
public record {Name}Command({Params}) : IRequest<{ReturnType}>;
  ]],
			{
				Name = ls.insert_node(1, "CreateUser"),
				Params = ls.insert_node(2, "string Name"),
				ReturnType = ls.insert_node(3, "Guid"),
			}
		)
	),
}
