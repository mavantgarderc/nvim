local map = vim.keymap.set

map({ "n", "x", "o" }, "ff", function()
    require("flash").jump()
end, { desc = "Flash jump" })

map({ "n", "x", "o" }, "<M-s>", function()
    require("flash").treesitter()
end, { desc = "Flash treesitter" })

map("x", "R", function()
    require("flash").treesitter_search()
end, { desc = "Treesitter search" })

map({ "n", "x", "o" }, "fl", function()
    require("flash").jump({
        search = { mode = "search", max_length = 0 },
        label = { after = { 0, 0 } },
        pattern = "^" })
end, { desc = "Flash to line" })

map({ "n", "x", "o" }, "<leader>fe", function()
    require("flash").jump({
        pattern = "$", search = { mode = "search", max_length = 0 }, label = { after = { 0, 0 } }, })
end, { desc = "Flash line end" })

map({ "n", "x", "o" }, "T", function()
    require("flash").jump({
        search = { mode = "search", max_length = 1, forward = false },
        label  = { after = { 0, 0 } }, pattern = "\\v.{-}\\zs.",
        before = true, inclusive = false, })
end, { desc = "Flash T" })

map({ "n", "x", "o" }, "zg", function()
    require("flash").jump({ search = { mode = "fuzzy" }, label = { after = { 0, 0 } }, })
end, { desc = "Flash fuzzy search" })

map({ "n", "x", "o" }, ";;", function()
    require("flash").jump({ continue = true })
end, { desc = "Continue flash" })

-- === === === === === === === === === === === === === === === === === === === === === === === === === === === === === ===

local categories = {
    -- <leader>fv
    variable = {
        keywords = {
            "var", "let", "const",
            "local", "global", "int",
            "string", "float", "double",
            "bool", "boolean", "char",
            "byte", "short", "long",
            "auto", "static", "extern",
            "register", "volatile", "mutable",
            "final", "readonly",
        },
        hl_group = "FlashVariable",
    },
    -- <leader>fc
    class = {
        keywords = {
            "class", "struct", "interface",
            "enum", "union", "trait",
            "protocol", "namespace", "module",
            "package", "type", "typedef",
            "using", "alias", "record",
            "data", "newtype",
        },
        hl_group = "FlashClass",
    },
    -- <leader>fm
    method = {
        keywords = {
            "function", "def", "method",
            "func", "fn", "proc",
            "sub", "routine", "lambda",
            "arrow", "async", "await",
            "yield", "generator", "constructor",
            "destructor", "operator", "macro",
        },
        hl_group = "FlashMethod",
    },
    -- <leader>fa
    access = {
        keywords = {
            "private", "public", "protected",
            "internal", "package", "export",
            "import", "from", "as",
            "default", "static", "abstract",
            "virtual", "override", "final",
            "sealed", "partial",
        },
        hl_group = "FlashAccess",
    },
    -- <leader>fl
    conditionals = {
        keywords = {
            "if", "else", "elif",
            "elseif", "unless", "when",
            "case", "switch", "match",
            "guard", "try", "catch",
            "except", "finally", "rescue",
            "ensure", "raise", "throw",
            "assert",
        },
        hl_group = "FlashConditionals",
    },
    -- <leader>fi
    iterators = {
        keywords = {
            "for", "foreach", "while",
            "do", "loop", "repeat",
            "until", "continue", "break",
            "next", "redo", "retry",
            "goto", "return", "exit",
            "yield", "each", "map",
            "filter", "reduce",
        },
        hl_group = "FlashIterators",
    },
    -- <leader>fo
    operators = {
        keywords = {
            "and", "or", "not",
            "AND", "OR", "NOT",
            "in", "is", "typeof",
            "instanceof", "new", "delete",
            "sizeof", "alignof", "decltype",
            "typeid", "const_cast", "static_cast",
            "dynamic_cast", "reinterpret_cast",
        },
        hl_group = "FlashOperators",
    },
    -- <leader>fk
    constants = {
        keywords = {
            "true", "false", "null",
            "nil", "none", "undefined",
            "void", "this", "self",
            "super", "base", "parent",
            "prototype", "__proto__", "constructor",
            "typeof",
        },
        hl_group = "FlashConstants",
    },
    -- <leader>ft
    comments = {
        keywords = {
            "TODO", "FIXME", "NOTE",
            "HACK", "XXX", "BUG",
            "DEPRECATED", "REVIEW", "OPTIMIZE",
            "WARNING", "IMPORTANT", "QUESTION",
            "IDEA", "REFACTOR",
        },
        hl_group = "FlashComments",
    },
}

-- === === === === === === === === === === === === === === === === === === === === === === === === === === === === === ===

local function create_pattern(keywords)
  return "\\<\\(" .. table.concat(keywords, "\\|") .. "\\)\\>"
end

map({ "n", "x", "o" }, "<leader>fv", function()
  require("flash").jump({
    pattern = create_pattern(categories.variable.keywords),
    search = { mode = "search" },
    label = { after = { 0, 0 } },
    highlight = { groups = { match = "FlashVariable" } }
}) end, { desc = "Flash variables" })

map({ "n", "x", "o" }, "<leader>fc", function()
  require("flash").jump({
    pattern = create_pattern(categories.class.keywords),
    search = { mode = "search" },
    label = { after = { 0, 0 } },
    highlight = { groups = { match = "FlashClass" } }
}) end, { desc = "Flash classes" })

map({ "n", "x", "o" }, "<leader>fm", function()
  require("flash").jump({
    pattern = create_pattern(categories.method.keywords),
    search = { mode = "search" },
    label = { after = { 0, 0 } },
    highlight = { groups = { match = "FlashMethod" } }
}) end, { desc = "Flash methods" })

map({ "n", "x", "o" }, "<leader>fa", function()
  require("flash").jump({
    pattern = create_pattern(categories.access.keywords),
    search = { mode = "search" },
    label = { after = { 0, 0 } },
    highlight = { groups = { match = "FlashAccess" } }
}) end, { desc = "Flash access modifiers" })

map({ "n", "x", "o" }, "<leader>fl", function()
  require("flash").jump({
    pattern = create_pattern(categories.conditionals.keywords),
    search = { mode = "search" },
    label = { after = { 0, 0 } },
    highlight = { groups = { match = "FlashConditionals" } }
}) end, { desc = "Flash conditionals" })

map({ "n", "x", "o" }, "<leader>fi", function()
  require("flash").jump({
    pattern = create_pattern(categories.iterators.keywords),
    search = { mode = "search" },
    label = { after = { 0, 0 } },
    highlight = { groups = { match = "FlashIterators" } }
}) end, { desc = "Flash loops/iterators" })

map({ "n", "x", "o" }, "<leader>fo", function()
  require("flash").jump({
    pattern = create_pattern(categories.operators.keywords),
    search = { mode = "search" },
    label = { after = { 0, 0 } },
    highlight = { groups = { match = "FlashOperators" } }
  })
end, { desc = "Flash operators" })

map({ "n", "x", "o" }, "<leader>fk", function()
  require("flash").jump({
    pattern = create_pattern(categories.constants.keywords),
    search = { mode = "search" },
    label = { after = { 0, 0 } },
    highlight = { groups = { match = "FlashConstants" } }
}) end, { desc = "Flash constants" })

map({ "n", "x", "o" }, "<leader>ft", function()
  require("flash").jump({
    pattern = create_pattern(categories.comments.keywords),
    search = { mode = "search" },
    label = { after = { 0, 0 } },
    highlight = { groups = { match = "FlashComments" } }
}) end, { desc = "Flash comment tags" })
