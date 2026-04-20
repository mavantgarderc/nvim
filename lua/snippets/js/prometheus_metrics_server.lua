local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"pmetrics",
		fmt(
			[[
const express = require("express");
const client = require("prom-client");

const app = express();

const register = new client.Registry();
client.collectDefaultMetrics({ register });

app.get("/metrics", async (req, res) => {{
  res.set("Content-Type", register.contentType);
  res.end(await register.metrics());
}});

module.exports = app;
  ]],
			{}
		)
	),
}
