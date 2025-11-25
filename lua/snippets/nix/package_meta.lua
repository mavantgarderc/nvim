local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
  s({
    trig = "pmeta",
    name = "Full Package Meta Block",
    desc = "Complete meta attribute set for packages, including description and longDescription, per Nixpkgs manual.",
  }, {
    t("meta = with lib; {"),
    t({ "", '  description = "' }),
    i(1, "Short description."),
    t('";'),
    t({ "", "  longDescription = ''" }),
    t({ "", "    " }),
    i(2, "Longer detailed description."),
    t({ "", "  '';" }),
    t({ "", '  homepage = "' }),
    i(3, "https://example.com"),
    t('";'),
    t({ "", "  license = licenses." }),
    i(4, "mit"),
    t(";"),
    t({ "", "  maintainers = with maintainers; [ " }),
    i(5, "maintainer-name"),
    t(" ];"),
    t({ "", "};" }),
  }),
}
