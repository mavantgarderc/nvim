local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local i = ls.insert_node

return {
	s(
		"fschema",
		fmt(
			[[
fastify.route({{
  method: '{}',
  url: '{}',
  schema: {{
    body: {{
      type: 'object',
      properties: {{
        {}
      }},
      required: []
    }}
  }},
  handler: async (request, reply) => {{
    {}
    return {{ ok: true }};
  }}
}});
]],
			{
				i(1, "POST"),
				i(2, "/api"),
				i(3, "name: { type: 'string' }"),
				i(4),
			}
		)
	),
}
