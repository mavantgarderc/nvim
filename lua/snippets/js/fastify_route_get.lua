local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"fget",
		fmt(
			[[
fastify.get('{}', async (request, reply) => {{
  {}
  return {{ ok: true }};
}});
]],
			{ i(1, "/"), i(2) }
		)
	),
}
