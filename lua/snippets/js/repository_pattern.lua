local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"repo",
		fmt(
			[[
class {Name}Repository {{
  constructor(db) {{
    this.db = db;
  }}

  async findById(id) {{
    return this.db.{query}(id);
  }}

  async create(data) {{
    return this.db.{create}(data);
  }}
}}

module.exports = {Name}Repository;
  ]],
			{
				Name = ls.insert_node(1, "User"),
				query = ls.insert_node(2, "findOne"),
				create = ls.insert_node(3, "insert"),
			}
		)
	),
}
