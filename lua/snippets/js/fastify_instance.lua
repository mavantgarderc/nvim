local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"fimp",
		fmt(
			[[
import Fastify from 'fastify';
const fastify = Fastify({{
  logger: true
}});
]],
			{}
		)
	),
}
