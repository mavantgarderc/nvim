local map = vim.keymap.set
local api = vim.api
local g = vim.g

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

map({ "n", "x", "o" }, "T", function()
    require("flash").jump({
        search = { mode = "search", max_length = 1, forward = false },
        label  = { after = { 0, 0 } }, pattern = "\\v.{-}\\zs.",
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

-- map({ "n", "x", "o" }, "<leader>fc", function() -- class keywords jump
--     require("flash").jump({
--         pattern = "\\<\\(class\\|method\\|def\\|function\\|private\\|public\\|protected\\|internal\\|sealed\\|sealed\\|struct\\|interface\\|enum\\|proc\\)\\>",
--         search = { mode = "search" }, label = { after = { 0, 0 } }, })
-- end, { desc = "Flash to classes, methods, etc." })

map({ "n", "x", "o" }, "<leader>fv", function() -- variable jumps
    require("flash").jump({
        pattern = "\\<\\(var\\|let\\|const\\|local\\|global\\|int\\|string\\)\\>",
        search = { mode = "search" }, label = { after = { 0, 0 } }, })
end, { desc = "Flash variables" })

map({ "n", "x", "o" }, "<leader>fi", function() -- conditional statements jumps
    require("flash").jump({
        pattern = "\\<\\(if\\|else\\|elif\\|unless\\)\\>",
        search = { mode = "search" }, label = { after = { 0, 0 } }, })
end, { desc = "Flash conditionals" })

map({ "n", "x", "o" }, "<leader>fo", function() -- iteration statements jumps
    require("flash").jump({
        pattern = "\\<\\(for\\|foreach\\|while\\|do\\|loop\\|repeat\\)\\>",
        search = { mode = "search" }, label = { after = { 0, 0 } }, })
end, { desc = "Flash loops" })

local categories = {
    class = {
        keywords = {"class", "struct", "interface", "enum", "proc"},
        hl_group = "FlashClass"
    },
    method = {
        keywords = {"method", "def", "function"},
        hl_group = "FlashMethod"
    },
    access = {
        keywords = {"private", "public", "protected", "internal"},
        hl_group = "FlashAccess"
    },
    modifier = {
        keywords = {"sealed"},
        hl_group = "FlashModifier"
    }
}

map({ "n", "x", "o" }, "<leader>fc", function()
    require("flash").jump({
        patterns = patterns,
        search = { mode = "search" },
        label = { after = { 0, 0 } },
    })
end, { desc = "Flash to classes, methods, etc." })





local function get_hl_color(group, attr)
  local hl = api.nvim_get_hl(0, { name = group })
  return hl[attr] and string.format("#%06x", hl[attr]) or nil
end

local function setup_flash_highlights()
  local function get_hl_color(group, attr)
    local hl = vim.api.nvim_get_hl(0, { name = group })
    return hl[attr] and string.format("#%06x", hl[attr]) or nil
  end

  -- Get theme-dependent colors
  local search_bg  = get_hl_color("Search", "bg") or get_hl_color("IncSearch", "bg") or "#ff9900"
  local search_fg  = get_hl_color("Search", "fg") or get_hl_color("IncSearch", "fg") or "#000000"
  local error_bg   = get_hl_color("ErrorMsg", "bg") or get_hl_color("DiagnosticError", "fg") or "#ff0000"
  local error_fg   = get_hl_color("ErrorMsg", "fg") or "#ffffff"
  local comment_fg = get_hl_color("Comment", "fg") or "#545c7e"
  local visual_bg  = get_hl_color("Visual", "bg") or get_hl_color("CursorLine", "bg") or "#ff007c"
  local visual_fg  = get_hl_color("Visual", "fg") or "#ffffff"
  local keyword_fg = get_hl_color("Keyword", "fg") or get_hl_color("Function", "fg") or "#ff9900"

  -- Set Flash highlights
  vim.api.nvim_set_hl(0, "FlashMatch",      { bg = search_bg, fg = search_fg, bold = true })
  vim.api.nvim_set_hl(0, "FlashCurrent",    { bg = error_bg,  fg = error_fg,  bold = true })
  vim.api.nvim_set_hl(0, "FlashBackdrop",   { fg = comment_fg })
  vim.api.nvim_set_hl(0, "FlashLabel",      { bg = visual_bg, fg = visual_fg, bold = true })
  vim.api.nvim_set_hl(0, "FlashPromptIcon", { fg = keyword_fg })
end

-- Apply highlights on startup
setup_flash_highlights()

-- Reapply when colorscheme changes
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = setup_flash_highlights
})
local patterns = {}
for _, cat in pairs(categories) do
    table.insert(patterns, {
        pattern = "\\<\\(" .. table.concat(cat.keywords, "\\|") .. "\\)\\>",
        hl_group = cat.hl_group
    })
end
api.nvim_create_autocmd("ColorScheme", {
    pattern = "*",
    callback = function()
        api.nvim_set_hl(0, "FlashClass", { link = "Type" })
        api.nvim_set_hl(0, "FlashMethod", { link = "Function" })
        api.nvim_set_hl(0, "FlashAccess", { link = "StorageClass" })
        api.nvim_set_hl(0, "FlashModifier", { link = "Keyword" })
    end
})

api.nvim_exec_autocmds("ColorScheme", { pattern = g.colors_name or "default" })
