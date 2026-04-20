local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"batch",
		fmt(
			[[
function createBatcher(interval, handler) {{
  let buffer = [];

  setInterval(async () => {{
    if (buffer.length > 0) {{
      const items = buffer;
      buffer = [];
      await handler(items);
    }}
  }}, interval);

  return (item) => buffer.push(item);
}}

module.exports = createBatcher;
  ]],
			{}
		)
	),
}
