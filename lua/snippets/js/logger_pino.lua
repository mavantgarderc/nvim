local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"pino",
		fmt(
			[[
const pino = require("pino");

const logger = pino({{
  level: process.env.LOG_LEVEL || "info",
  transport: {{
    target: "pino-pretty",
    options: {{
      colorize: true,
      translateTime: "SYS:standard"
    }}
  }}
}});

module.exports = logger;
  ]],
			{}
		)
	),
}
