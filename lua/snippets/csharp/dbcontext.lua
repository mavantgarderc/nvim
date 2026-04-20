local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"dbctx",
		fmt(
			[[
public class {Name} : DbContext
{{
    public {Name}(DbContextOptions<{Name}> options) : base(options) {{ }}

    public DbSet<{Entity}> {Set} {{ get; set; }} = default!;
}}
  ]],
			{
				Name = ls.insert_node(1, "AppDbContext"),
				Entity = ls.insert_node(2, "UserEntity"),
				Set = ls.insert_node(3, "Users"),
			}
		)
	),
}
