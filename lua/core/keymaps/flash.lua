local map = vim.keymap.set
local tbl_map = vim.tbl_map
local diagnostic = vim.diagnostic
local api = vim.api

-- "o" mode is: execute, then go back to insert mode
-- "x" mode is: activated only in visual mode

map({ "n", "x", "o" }, "ff", function() -- jump
    require("flash").jump()
end, { desc = "Flash jump" })

map({ "n", "x", "o" }, "<M-s>", function() -- treesitter jump
    require("flash").treesitter()
end, { desc = "Flash treesitter" })

map("x", "R", function()
    require("flash").treesitter_search()
end, { desc = "Treesitter search" })

map({ "n", "x", "o" }, "fl", function() -- Line jumping
    require("flash").jump({ search = { mode = "search", max_length = 0 }, label = { after = { 0, 0 } }, pattern = "^" })
end, { desc = "Flash to line" })

map({ "n", "x", "o" }, "<leader>fe", function() -- end of the line jumping
    require("flash").jump({
        pattern = "$", search = { mode = "search", max_length = 0 }, label = { after = { 0, 0 } }, })
end, { desc = "Flash line end" })

map({ "n", "x", "o" }, "gz", function() -- Function/method jumping
    require("flash").jump({ pattern =
        "function\\|def\\|class\\|public\\|private\\|protected\\|internal\\|sealed\\|override" })
end, { desc = "Flash to function" })

map({ "n", "x", "o" }, "T", function()
    require("flash").jump({
        search = { mode = "search", max_length = 1, forward = false },
        label = { after = { 0, 0 } }, pattern = "\\v.{-}\\zs.",
        before = true, inclusive = false, })
end, { desc = "Flash T" })

map({ "n", "x", "o" }, "za", function() -- Fuzzy search
    require("flash").jump({ search = { mode = "fuzzy" }, label = { after = { 0, 0 } }, })
end, { desc = "Flash fuzzy search" })

map({ "n", "x", "o" }, ";;", function() -- Continue last search
    require("flash").jump({ continue = true })
end, { desc = "Continue flash" })

map("n", "<leader>fz", function()
    require("flash").jump({ search = { mode = "fuzzy" }, label = { after = { 0, 0 } }, })
end, { desc = "Flash fuzzy" })

map({ "n", "x", "o" }, "<leader>fp", function() -- Special characters jumping
    require("flash").jump({
        pattern = "[{(.!?/@#$%^&*)}]",
        search = { mode = "search" }, label = { after = { 0, 0 } }, })
end, { desc = "Flash punctuation" })

-- Code-specific jumps
map({ "n", "x", "o" }, "<leader>fv", function()
    require("flash").jump({
        pattern = "\\<\\(var\\|let\\|const\\|local\\|global\\|int\\|string\\)\\>",
        search = { mode = "search" }, label = { after = { 0, 0 } }, })
end, { desc = "Flash variables" })

map({ "n", "x", "o" }, "<leader>fi", function()
    require("flash").jump({
        pattern = "\\<\\(if\\|else\\|elif\\|unless\\)\\>",
        search = { mode = "search" }, label = { after = { 0, 0 } }, })
end, { desc = "Flash conditionals" })

map({ "n", "x", "o" }, "<leader>fo", function()
    require("flash").jump({
        pattern = "\\<\\(for\\|foreach\\|while\\|do\\|loop\\|repeat\\)\\>",
        search = { mode = "search" }, label = { after = { 0, 0 } }, })
end, { desc = "Flash loops" })

map({ "n", "x", "o" }, "<leader>fc", function()
    require("flash").jump({
        pattern = "\\<\\(class\\|struct\\|interface\\|enum\\)\\>",
        search = { mode = "search" }, label = { after = { 0, 0 } }, })
end, { desc = "Flash classes" })

map({ "n", "x", "o" }, "<leader>fm", function()
    require("flash").jump({
        pattern = "\\<\\(function\\|def\\|method\\|proc\\)\\>",
        search = { mode = "search" }, label = { after = { 0, 0 } }, })
end, { desc = "Flash methods" })
