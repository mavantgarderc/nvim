local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"irepo",
		fmt(
			[[
public interface I{Name}Repository
{{
    Task<{Entity}> GetByIdAsync({IdType} id);
    Task<IEnumerable<{Entity}>> GetAllAsync();
    Task AddAsync({Entity} entity);
    Task UpdateAsync({Entity} entity);
    Task DeleteAsync({IdType} id);
}}
  ]],
			{
				Name = ls.insert_node(1, "User"),
				Entity = ls.insert_node(2, "UserEntity"),
				IdType = ls.insert_node(3, "Guid"),
			}
		)
	),
}
