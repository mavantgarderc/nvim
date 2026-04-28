local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"health",
		fmt(
			[[
const express = require("express");
const router = express.Router();

router.get("/healthz", (req, res) => res.json({{ ok: true }}));
router.get("/readyz", (req, res) => {{
  {logic}
}});

module.exports = router;
  ]],
			{
				logic = ls.insert_node(1, "res.json({ ready: true })"),
			}
		)
	),
}
