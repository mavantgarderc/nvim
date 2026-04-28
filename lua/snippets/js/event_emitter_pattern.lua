local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"evt",
		fmt(
			[[
const EventEmitter = require("events");

class {Bus} extends EventEmitter {{
  emitEvent(event, payload) {{
    this.emit(event, payload);
  }}

  onEvent(event, listener) {{
    this.on(event, listener);
  }}
}}

module.exports = new {Bus}();
  ]],
			{
				Bus = ls.insert_node(1, "AppBus"),
			}
		)
	),
}
