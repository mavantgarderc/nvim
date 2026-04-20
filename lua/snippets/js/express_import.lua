local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"eimp",
		fmt(
			[[
import express from 'express';
const app = express();
app.use(express.json());
]],
			{}
		)
	),
}
