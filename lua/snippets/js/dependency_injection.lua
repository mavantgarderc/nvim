local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"di",
		fmt(
			[[
class Container {{
  constructor() {{
    this.registry = new Map();
  }}

  register(key, value) {{
    this.registry.set(key, value);
  }}

  resolve(key) {{
    return this.registry.get(key);
  }}
}}

const container = new Container();
module.exports = container;
  ]],
			{}
		)
	),
}
