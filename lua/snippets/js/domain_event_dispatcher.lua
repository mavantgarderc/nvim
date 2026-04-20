local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"domevt",
		fmt(
			[[
class DomainEvents {{
  constructor() {{
    this.handlers = new Map();
  }}

  register(event, handler) {{
    if (!this.handlers.has(event)) this.handlers.set(event, []);
    this.handlers.get(event).push(handler);
  }}

  async dispatch(event, payload) {{
    const handlers = this.handlers.get(event) || [];
    for (const h of handlers) await h(payload);
  }}
}}

module.exports = new DomainEvents();
  ]],
			{}
		)
	),
}
