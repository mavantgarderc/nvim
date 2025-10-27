local map = vim.keymap.set

map({ "n", "x", "o" }, "fjf", function()
  require("flash").jump()
end, { desc = "Flash jump" })

map({ "n", "x", "o" }, "<M-s>", function()
  require("flash").treesitter()
end, { desc = "Flash treesitter" })

map({ "n", "x", "o" }, "fjl", function()
  require("flash").jump({ search = { mode = "search", max_length = 0 }, label = { after = { 0, 0 } }, pattern = "^" })
end, { desc = "Flash to line" })

map({ "n", "x", "o" }, "<leader>fje", function()
  require("flash").jump({ pattern = "$", search = { mode = "search", max_length = 0 }, label = { after = { 0, 0 } } })
end, { desc = "Flash line end" })

map({ "n", "x", "o" }, "fjz", function()
  require("flash").jump({ search = { mode = "fuzzy" }, label = { after = { 0, 0 } } })
end, { desc = "Flash fuzzy search" })

map({ "n", "x", "o" }, ";;", function()
  require("flash").jump({ continue = true })
end, { desc = "Continue flash" })

-- === === === === === === === === === === ===

local categories = {
  -- <leader>fcv
  variable = {
    keywords = {
      "var",
      "let",
      "const",
      "local",
      "global",
      "int",
      "string",
      "float",
      "double",
      "bool",
      "boolean",
      "char",
      "byte",
      "short",
      "long",
      "auto",
      "static",
      "extern",
      "register",
      "volatile",
      "mutable",
      "final",
      "readonly",
    },
    hl_group = "FlashVariable",
  },
  -- <leader>fcc
  class = {
    keywords = {
      "class",
      "struct",
      "interface",
      "enum",
      "union",
      "trait",
      "protocol",
      "namespace",
      "module",
      "package",
      "type",
      "typedef",
      "using",
      "alias",
      "record",
      "data",
      "newtype",
    },
    hl_group = "FlashClass",
  },
  -- <leader>fcm
  method = {
    keywords = {
      "function",
      "def",
      "method",
      "func",
      "fn",
      "proc",
      "sub",
      "routine",
      "lambda",
      "arrow",
      "async",
      "await",
      "yield",
      "generator",
      "constructor",
      "destructor",
      "operator",
      "macro",
    },
    hl_group = "FlashMethod",
  },
  -- <leader>fca
  access = {
    keywords = {
      "private",
      "public",
      "protected",
      "internal",
      "package",
      "export",
      "import",
      "from",
      "as",
      "default",
      "static",
      "abstract",
      "virtual",
      "override",
      "final",
      "sealed",
      "partial",
    },
    hl_group = "FlashAccess",
  },
  -- <leader>fcl
  conditionals = {
    keywords = {
      "if",
      "else",
      "elif",
      "elseif",
      "unless",
      "when",
      "case",
      "switch",
      "match",
      "guard",
      "try",
      "catch",
      "except",
      "finally",
      "rescue",
      "ensure",
      "raise",
      "throw",
      "assert",
    },
    hl_group = "FlashConditionals",
  },
  -- <leader>fci
  iterators = {
    keywords = {
      "for",
      "foreach",
      "while",
      "do",
      "loop",
      "repeat",
      "until",
      "continue",
      "break",
      "next",
      "redo",
      "retry",
      "goto",
      "return",
      "exit",
      "yield",
      "each",
      "map",
      "filter",
      "reduce",
    },
    hl_group = "FlashIterators",
  },
  -- <leader>fco
  operators = {
    keywords = {
      "and",
      "or",
      "not",
      "AND",
      "OR",
      "NOT",
      "in",
      "is",
      "typeof",
      "instanceof",
      "new",
      "delete",
      "sizeof",
      "alignof",
      "decltype",
      "typeid",
      "const_cast",
      "static_cast",
      "dynamic_cast",
      "reinterpret_cast",
    },
    hl_group = "FlashOperators",
  },
  -- <leader>fck
  constants = {
    keywords = {
      "true",
      "false",
      "null",
      "nil",
      "none",
      "undefined",
      "void",
      "this",
      "self",
      "super",
      "base",
      "parent",
      "prototype",
      "__proto__",
      "constructor",
      "typeof",
    },
    hl_group = "FlashConstants",
  },
  -- <leader>fct
  comments = {
    keywords = {
      "TODO",
      "FIXME",
      "NOTE",
      "HACK",
      "XXX",
      "BUG",
      "DEPRECATED",
      "REVIEW",
      "OPTIMIZE",
      "WARNING",
      "IMPORTANT",
      "QUESTION",
      "IDEA",
      "REFACTOR",
    },
    hl_group = "FlashComments",
  },
}

-- === === === === === === === === === === ===

local function create_pattern(keywords)
  return "\\<\\(" .. table.concat(keywords, "\\|") .. "\\)\\>"
end

map({ "n", "x", "o" }, "<leader>fcv", function()
  require("flash").jump({
    pattern = create_pattern(categories.variable.keywords),
    search = { mode = "search" },
    label = { after = { 0, 0 } },
    highlight = { groups = { match = "FlashVariable" } },
  })
end, { desc = "Flash variables" })

map({ "n", "x", "o" }, "<leader>fcc", function()
  require("flash").jump({
    pattern = create_pattern(categories.class.keywords),
    search = { mode = "search" },
    label = { after = { 0, 0 } },
    highlight = { groups = { match = "FlashClass" } },
  })
end, { desc = "Flash classes" })

map({ "n", "x", "o" }, "<leader>fcm", function()
  require("flash").jump({
    pattern = create_pattern(categories.method.keywords),
    search = { mode = "search" },
    label = { after = { 0, 0 } },
    highlight = { groups = { match = "FlashMethod" } },
  })
end, { desc = "Flash methods" })

map({ "n", "x", "o" }, "<leader>fca", function()
  require("flash").jump({
    pattern = create_pattern(categories.access.keywords),
    search = { mode = "search" },
    label = { after = { 0, 0 } },
    highlight = { groups = { match = "FlashAccess" } },
  })
end, { desc = "Flash access modifiers" })

map({ "n", "x", "o" }, "<leader>fcl", function()
  require("flash").jump({
    pattern = create_pattern(categories.conditionals.keywords),
    search = { mode = "search" },
    label = { after = { 0, 0 } },
    highlight = { groups = { match = "FlashConditionals" } },
  })
end, { desc = "Flash conditionals" })

map({ "n", "x", "o" }, "<leader>fci", function()
  require("flash").jump({
    pattern = create_pattern(categories.iterators.keywords),
    search = { mode = "search" },
    label = { after = { 0, 0 } },
    highlight = { groups = { match = "FlashIterators" } },
  })
end, { desc = "Flash loops/iterators" })

map({ "n", "x", "o" }, "<leader>fco", function()
  require("flash").jump({
    pattern = create_pattern(categories.operators.keywords),
    search = { mode = "search" },
    label = { after = { 0, 0 } },
    highlight = { groups = { match = "FlashOperators" } },
  })
end, { desc = "Flash operators" })

map({ "n", "x", "o" }, "<leader>fck", function()
  require("flash").jump({
    pattern = create_pattern(categories.constants.keywords),
    search = { mode = "search" },
    label = { after = { 0, 0 } },
    highlight = { groups = { match = "FlashConstants" } },
  })
end, { desc = "Flash constants" })

map({ "n", "x", "o" }, "<leader>fct", function()
  require("flash").jump({
    pattern = create_pattern(categories.comments.keywords),
    search = { mode = "search" },
    label = { after = { 0, 0 } },
    highlight = { groups = { match = "FlashComments" } },
  })
end, { desc = "Flash comment tags" })
