local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"ctrl",
		fmt(
			[[
class {}Controller {{
  constructor(service) {{
    this.service = service;
  }}

  async {}(req, res) {{
    const result = await this.service.{}({});
    res.json(result);
  }}
}}
]],
			{
				i(1, "User"),
				i(2, "getUser"),
				i(3, "findById"),
				i(4, "req.params.id"),
			}
		)
	),
}
