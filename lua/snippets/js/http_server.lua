local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep
local i = ls.insert_node

return {
	s(
		"http",
		fmt(
			[[
const http = require('http');

const server = http.createServer((req, res) => {{
  res.writeHead(200, {{ 'Content-Type': 'text/plain' }});
  res.end('{}');
}});

server.listen({}, () => {{
  console.log('Server running on port {}');
}});
]],
			{ i(1, "Hello World"), i(2, "3000"), rep(2) }
		)
	),
}
