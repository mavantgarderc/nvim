local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"efcfg",
		fmt(
			[[
public class {Name}Configuration : IEntityTypeConfiguration<{Entity}>
{{
    public void Configure(EntityTypeBuilder<{Entity}> builder)
    {{
        {body}
    }}
}}
  ]],
			{
				Name = ls.insert_node(1, "User"),
				Entity = ls.insert_node(2, "UserEntity"),
				body = ls.insert_node(3, "builder.HasKey(x => x.Id);"),
			}
		)
	),
}
