local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

-- Helper for environments
local function env_snip(env)
  return s(env, {
    t({ "\\begin{" .. env .. "}", "\t" }),
    i(1),
    t({ "", "\\end{" .. env .. "}" }),
    i(0),
  })
end

-- Wrap all snippets in a table keyed by filetype
ls.add_snippets("tex", {
  -- Math
  s("ff", { t("\\frac{"), i(1), t("}{"), i(2), t("}"), i(0) }),
  s("sq", { t("\\sqrt{"), i(1), t("}"), i(0) }),
  s("mk", { t("$"), i(1), t("$"), i(0) }),
  s("dm", { t({ "\\[", "\t" }), i(1), t({ "", "\\]" }), i(0) }),

  -- Greek letters
  s("aa", { t("\\alpha") }),
  s("bb", { t("\\beta") }),
  s("gg", { t("\\gamma") }),
  s("dd", { t("\\delta") }),

  -- Environments
  env_snip("align"),
  env_snip("equation"),
  env_snip("itemize"),
  env_snip("enumerate"),
})
