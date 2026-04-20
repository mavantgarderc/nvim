local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"cqcmd",
		fmt(
			[[
class {Command}Handler {{
  constructor({deps}) {{
    this.deps = {deps};
  }}

  async execute({payload}) {{
    {logic}
  }}
}}

module.exports = {Command}Handler;
  ]],
			{
				Command = ls.insert_node(1, "CreateUser"),
				deps = ls.insert_node(2, "{ repo }"),
				payload = ls.insert_node(3, "data"),
				logic = ls.insert_node(4, "// mutation logic"),
			}
		)
	),
}
