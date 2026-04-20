local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"fpost",
		fmt(
			[[
fastify.post('{}', async (request, reply) => {{
  const body = request.body;
  {}
  return {{ received: body }};
}});
]],
			{ i(1, "/submit"), i(2) }
		)
	),
}
