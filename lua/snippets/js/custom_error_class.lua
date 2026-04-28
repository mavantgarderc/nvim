local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"cerr",
		fmt(
			[[
class {Err} extends Error {{
  constructor(message, status = 400, meta = {{}}) {{
    super(message);
    this.status = status;
    this.meta = meta;
  }}
}}

module.exports = {Err};
  ]],
			{
				Err = ls.insert_node(1, "AppError"),
			}
		)
	),
}
