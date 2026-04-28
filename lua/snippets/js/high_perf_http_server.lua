local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"uws",
		fmt(
			[[
const uWS = require("uWebSockets.js");

uWS.App().get("/*", (res, req) => {{
  res.end("ok");
}}).listen({port}, (token) => {{
  if (token) console.log("listening on {port}");
}});
  ]],
			{
				port = ls.insert_node(1, "9000"),
			}
		)
	),
}
