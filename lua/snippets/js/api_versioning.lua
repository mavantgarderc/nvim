local ls = require("luasnip")
local s = ls.snippet
local fmt = require("luasnip.extras.fmt").fmt

return {
	s(
		"apiv",
		fmt(
			[[
const express = require("express");
const router = express.Router();

router.use("/v1", require("./v1"));
router.use("/v2", require("./v2"));

module.exports = router;
  ]],
			{}
		)
	),
}
