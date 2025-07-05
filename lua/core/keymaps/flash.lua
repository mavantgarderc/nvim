local keymap = vim.keymap.set

-- Basic navigation
keymap({ "n", "x", "o" }, "s", function() require("flash").jump() end, { desc = "Flash jump" })
keymap({ "n", "x", "o" }, "S", function() require("flash").treesitter() end, { desc = "Flash treesitter" })

-- Remote operations
keymap("o", "r", function() require("flash").remote() end, { desc = "Remote flash" })
keymap({ "o", "x" }, "R", function() require("flash").treesitter_search() end, { desc = "Treesitter search" })

-- Toggle in command mode
keymap("c", "<c-s>", function() require("flash").toggle() end, { desc = "Toggle flash search" })

-- Line jumping
keymap({ "n", "x", "o" }, "gl", function()
  require("flash").jump({
    search = { mode = "search", max_length = 0 },
    label = { after = { 0, 0 } },
    pattern = "^"
  })
end, { desc = "Flash to line" })

-- Word jumping
keymap({ "n", "x", "o" }, "gw", function()
  require("flash").jump({
    pattern = "\\<"
  })
end, { desc = "Flash to word" })

-- End of word
keymap({ "n", "x", "o" }, "ge", function()
  require("flash").jump({
    pattern = "\\>"
  })
end, { desc = "Flash to word end" })

-- Paragraph jumping
keymap({ "n", "x", "o" }, "gp", function()
  require("flash").jump({
    pattern = "^\\s*$"
  })
end, { desc = "Flash to paragraph" })

-- Function/method jumping
keymap({ "n", "x", "o" }, "gf", function()
  require("flash").jump({
    pattern = "function\\|def\\|class"
  })
end, { desc = "Flash to function" })

-- Bracket jumping
keymap({ "n", "x", "o" }, "gb", function()
  require("flash").jump({
    pattern = "[{}()\\[\\]]"
  })
end, { desc = "Flash to bracket" })

-- Quote jumping
keymap({ "n", "x", "o" }, "gq", function()
  require("flash").jump({
    pattern = "[\"'`]"
  })
end, { desc = "Flash to quote" })

-- Comment jumping (changed to avoid conflict with gc comment toggle)
keymap({ "n", "x", "o" }, "gC", function()
  require("flash").jump({
    pattern = "//\\|#\\|--\\|/\\*"
  })
end, { desc = "Flash to comment" })

-- Diagnostic jumping
keymap({ "n", "x", "o" }, "gd", function()
  require("flash").jump({
    matcher = function(win)
      return vim.tbl_map(function(diag)
        return {
          pos = { diag.lnum + 1, diag.col },
          end_pos = { diag.end_lnum + 1, diag.end_col - 1 },
        }
      end, vim.diagnostic.get(vim.api.nvim_win_get_buf(win)))
    end,
    action = function(match, state)
      vim.api.nvim_win_call(match.win, function()
        vim.api.nvim_win_set_cursor(match.win, match.pos)
        vim.diagnostic.open_float()
      end)
      state:hide()
    end,
  })
end, { desc = "Flash to diagnostic" })

-- Enhanced f/F/t/T motions
keymap({ "n", "x", "o" }, "f", function()
  require("flash").jump({
    search = { mode = "search", max_length = 1 },
    label = { after = { 0, 0 } },
    pattern = "\\v.{-}\\zs.",
    before = false,
    inclusive = false,
  })
end, { desc = "Flash f" })

keymap({ "n", "x", "o" }, "F", function()
  require("flash").jump({
    search = { mode = "search", max_length = 1, forward = false },
    label = { after = { 0, 0 } },
    pattern = "\\v.{-}\\zs.",
    before = false,
    inclusive = false,
  })
end, { desc = "Flash F" })

keymap({ "n", "x", "o" }, "t", function()
  require("flash").jump({
    search = { mode = "search", max_length = 1 },
    label = { after = { 0, 0 } },
    pattern = "\\v.{-}\\zs.",
    before = true,
    inclusive = false,
  })
end, { desc = "Flash t" })

keymap({ "n", "x", "o" }, "T", function()
  require("flash").jump({
    search = { mode = "search", max_length = 1, forward = false },
    label = { after = { 0, 0 } },
    pattern = "\\v.{-}\\zs.",
    before = true,
    inclusive = false,
  })
end, { desc = "Flash T" })

-- Window jumping (changed to avoid conflict with <leader>w)
keymap("n", "<leader>fw", function()
  require("flash").jump({
    pattern = ".", -- will be overridden
    search = { mode = "search", max_length = 0 },
    label = { after = { 0, 0 } },
    matcher = function(win)
      return { {
        win = win,
        pos = { 1, 0 },
        end_pos = { 1, 0 },
      } }
    end,
    action = function(match, state)
      vim.api.nvim_set_current_win(match.win)
      state:hide()
    end,
  })
end, { desc = "Flash window" })

-- Buffer jumping (changed to avoid conflict with <leader>b)
keymap("n", "<leader>fb", function()
  require("flash").jump({
    pattern = ".", -- will be overridden
    search = { mode = "search", max_length = 0 },
    label = { after = { 0, 0 } },
    matcher = function(win)
      return { {
        win = win,
        pos = { 1, 0 },
        end_pos = { 1, 0 },
      } }
    end,
    action = function(match, state)
      vim.api.nvim_set_current_win(match.win)
      state:hide()
    end,
  })
end, { desc = "Flash buffer" })

-- Fuzzy search
keymap({ "n", "x", "o" }, "z/", function()
  require("flash").jump({
    search = { mode = "fuzzy" },
    label = { after = { 0, 0 } },
  })
end, { desc = "Flash fuzzy search" })

-- Continue last search (using only double key versions to avoid conflicts)
keymap({ "n", "x", "o" }, ";;", function()
  require("flash").jump({ continue = true })
end, { desc = "Continue flash" })

-- Reverse continue (using only double key versions to avoid conflicts)
keymap({ "n", "x", "o" }, ",,", function()
  require("flash").jump({ continue = true, reverse = true })
end, { desc = "Reverse continue flash" })

-- Additional utility keymaps
keymap({ "n", "x", "o" }, "<leader>fs", function()
  require("flash").jump({
    search = { mode = "search" },
    label = { after = { 0, 0 } },
  })
end, { desc = "Flash search mode" })

keymap({ "n", "x", "o" }, "<leader>ft", function()
  require("flash").treesitter()
end, { desc = "Flash treesitter" })

keymap({ "n", "x", "o" }, "<leader>fr", function()
  require("flash").remote()
end, { desc = "Flash remote" })

keymap("n", "<leader>ff", function()
  require("flash").jump({
    search = { mode = "fuzzy" },
    label = { after = { 0, 0 } },
  })
end, { desc = "Flash fuzzy" })

-- Quick access to common patterns
keymap({ "n", "x", "o" }, "<leader>fl", function()
  require("flash").jump({
    pattern = "^",
    search = { mode = "search", max_length = 0 },
    label = { after = { 0, 0 } },
  })
end, { desc = "Flash line start" })

keymap({ "n", "x", "o" }, "<leader>fe", function()
  require("flash").jump({
    pattern = "$",
    search = { mode = "search", max_length = 0 },
    label = { after = { 0, 0 } },
  })
end, { desc = "Flash line end" })

keymap({ "n", "x", "o" }, "<leader>fw", function()
  require("flash").jump({
    pattern = "\\<\\w+\\>",
    search = { mode = "search" },
    label = { after = { 0, 0 } },
  })
end, { desc = "Flash word" })

keymap({ "n", "x", "o" }, "<leader>fW", function()
  require("flash").jump({
    pattern = "\\S+",
    search = { mode = "search" },
    label = { after = { 0, 0 } },
  })
end, { desc = "Flash WORD" })

-- Special characters jumping
keymap({ "n", "x", "o" }, "<leader>fp", function()
  require("flash").jump({
    pattern = "[.!?]",
    search = { mode = "search" },
    label = { after = { 0, 0 } },
  })
end, { desc = "Flash punctuation" })

keymap({ "n", "x", "o" }, "<leader>fn", function()
  require("flash").jump({
    pattern = "\\d+",
    search = { mode = "search" },
    label = { after = { 0, 0 } },
  })
end, { desc = "Flash numbers" })

keymap({ "n", "x", "o" }, "<leader>fu", function()
  require("flash").jump({
    pattern = "[A-Z]",
    search = { mode = "search" },
    label = { after = { 0, 0 } },
  })
end, { desc = "Flash uppercase" })

-- Code-specific jumps
keymap({ "n", "x", "o" }, "<leader>fv", function()
  require("flash").jump({
    pattern = "\\<\\(var\\|let\\|const\\|local\\)\\>",
    search = { mode = "search" },
    label = { after = { 0, 0 } },
  })
end, { desc = "Flash variables" })

keymap({ "n", "x", "o" }, "<leader>fi", function()
  require("flash").jump({
    pattern = "\\<\\(if\\|else\\|elif\\|unless\\)\\>",
    search = { mode = "search" },
    label = { after = { 0, 0 } },
  })
end, { desc = "Flash conditionals" })

keymap({ "n", "x", "o" }, "<leader>fo", function()
  require("flash").jump({
    pattern = "\\<\\(for\\|while\\|loop\\|repeat\\)\\>",
    search = { mode = "search" },
    label = { after = { 0, 0 } },
  })
end, { desc = "Flash loops" })

keymap({ "n", "x", "o" }, "<leader>fc", function()
  require("flash").jump({
    pattern = "\\<\\(class\\|struct\\|interface\\|enum\\)\\>",
    search = { mode = "search" },
    label = { after = { 0, 0 } },
  })
end, { desc = "Flash classes" })

keymap({ "n", "x", "o" }, "<leader>fm", function()
  require("flash").jump({
    pattern = "\\<\\(function\\|def\\|method\\|proc\\)\\>",
    search = { mode = "search" },
    label = { after = { 0, 0 } },
  })
end, { desc = "Flash methods" })

-- Configuration shortcuts
keymap("n", "<leader>fh", function()
  require("flash").jump({
    highlight = { backdrop = false },
    label = { after = { 0, 0 } },
  })
end, { desc = "Flash no backdrop" })

keymap("n", "<leader>fj", function()
  require("flash").jump({
    jump = { autojump = true },
    label = { after = { 0, 0 } },
  })
end, { desc = "Flash autojump" })

keymap("n", "<leader>fk", function()
  require("flash").jump({
    search = { multi_window = false },
    label = { after = { 0, 0 } },
  })
end, { desc = "Flash current window" })

-- Which-key integration setup function
function _G.setup_flash_which_key()
  if pcall(require, "which-key") then
    require("which-key").add({
      { "s", desc = "Flash jump" },
      { "S", desc = "Flash treesitter" },
      { "g", group = "Flash extended" },
      { "gl", desc = "Flash to line" },
      { "gw", desc = "Flash to word" },
      { "ge", desc = "Flash to word end" },
      { "gp", desc = "Flash to paragraph" },
      { "gf", desc = "Flash to function" },
      { "gb", desc = "Flash to bracket" },
      { "gq", desc = "Flash to quote" },
      { "gC", desc = "Flash to comment" },
      { "gd", desc = "Flash to diagnostic" },
      { "<leader>fw", desc = "Flash window" },
      { "<leader>fb", desc = "Flash buffer" },
      { "<leader>f", group = "Flash" },
      { "<leader>fs", desc = "Flash search mode" },
      { "<leader>ft", desc = "Flash treesitter" },
      { "<leader>fr", desc = "Flash remote" },
      { "<leader>ff", desc = "Flash fuzzy" },
      { "<leader>fl", desc = "Flash line start" },
      { "<leader>fe", desc = "Flash line end" },
      { "<leader>fw", desc = "Flash word" },
      { "<leader>fW", desc = "Flash WORD" },
      { "<leader>fp", desc = "Flash punctuation" },
      { "<leader>fn", desc = "Flash numbers" },
      { "<leader>fu", desc = "Flash uppercase" },
      { "<leader>fv", desc = "Flash variables" },
      { "<leader>fi", desc = "Flash conditionals" },
      { "<leader>fo", desc = "Flash loops" },
      { "<leader>fc", desc = "Flash classes" },
      { "<leader>fm", desc = "Flash methods" },
      { "<leader>fh", desc = "Flash no backdrop" },
      { "<leader>fj", desc = "Flash autojump" },
      { "<leader>fk", desc = "Flash current window" },
      { "z/", desc = "Flash fuzzy search" },
      { ";;", desc = "Continue flash" },
      { ",,", desc = "Reverse continue flash" },
    })
  end
end
