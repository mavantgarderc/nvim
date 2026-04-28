local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"repo",
		fmt(
			[[
public class {Name}Repository : I{Name}Repository
{{
    private readonly {DbContext} _context;

    public {Name}Repository({DbContext} context)
    {{
        _context = context;
    }}

    public async Task<{Entity}> GetByIdAsync({IdType} id)
        => await _context.{Set}.FindAsync(id);
}}
  ]],
			{
				Name = ls.insert_node(1, "User"),
				DbContext = ls.insert_node(2, "AppDbContext"),
				Entity = ls.insert_node(3, "UserEntity"),
				IdType = ls.insert_node(4, "Guid"),
				Set = ls.insert_node(5, "Users"),
			}
		)
	),
}
