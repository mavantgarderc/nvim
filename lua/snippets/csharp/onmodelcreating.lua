local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"onmodel",
		fmt(
			[[
protected override void OnModelCreating(ModelBuilder modelBuilder)
{{
    {body}
}}
  ]],
			{
				body = ls.insert_node(
					1,
					"modelBuilder.ApplyConfigurationsFromAssembly(typeof(AppDbContext).Assembly);"
				),
			}
		)
	),
}
