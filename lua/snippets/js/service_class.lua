local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"svc",
		fmt(
			[[
class {}Service {{
  constructor({}) {{
    {}
  }}

  async {}({}) {{
    {}
  }}
}}

export default {}Service;
]],
			{
				i(1, "User"),
				i(2, "repo"),
				i(3, "this.repo = repo"),
				i(4, "findById"),
				i(5, "id"),
				i(6, "return this.repo.find(id);"),
				i(7, "User"),
			}
		)
	),
}
