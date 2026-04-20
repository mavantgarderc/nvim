local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"repo",
		fmt(
			[[
class {}Repository {{
  constructor(db) {{
    this.db = db;
  }}

  async create(data) {{
    return this.db.insert(data);
  }}

  async find(id) {{
    return this.db.findById(id);
  }}
}}
]],
			{
				i(1, "User"),
			}
		)
	),
}
