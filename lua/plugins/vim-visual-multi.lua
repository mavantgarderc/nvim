local g = vim.g

return {
  "mg979/vim-visual-multi",
  branch = "master",
  init = function()
    -- Disable default mappings to avoid conflicts
    g.VM_default_mappings = 0

    -- Theme and appearance
    g.VM_theme = "iceblue"
    g.VM_highlight_matches = "underline"

    -- Behavior settings
    g.VM_live_editing = 1 -- Enable live editing
    g.VM_silent_exit = 1 -- Don't show exit message
    g.VM_show_warnings = 1 -- Show warnings
    g.VM_case_setting = "smart" -- Smart case matching
    g.VM_use_first_cursor_in_line = 0 -- Don't use first cursor in line
    g.VM_skip_shorter_lines = 0 -- Don't skip shorter lines
    g.VM_extend_matches = 0 -- Don't extend matches automatically
    g.VM_reselect_first = 1 -- Reselect first match

    -- Performance settings
    g.VM_max_find = 1000 -- Maximum number of matches to find
    g.VM_max_matches = 1000 -- Maximum number of matches to highlight

    -- Insert mode settings
    g.VM_insert_special_keys = { "c-v", "c-a", "c-e", "c-u", "c-w", "c-r", "c-h", "c-k" }

    -- Custom mappings - these will be set in the keymaps file
    g.VM_maps = {
      -- Basic cursor operations
      ["Find Under"] = "<C-n>",
      ["Find Subword Under"] = "<C-n>",
      ["Select All"] = "<C-S-n>",
      ["Start Regex Search"] = "<C-/>",
      ["Add Cursor Down"] = "<A-S-j>",
      ["Add Cursor Up"] = "<A-S-k>",
      ["Add Cursor At Pos"] = "<A-S-l>",
      ["Add Cursor At Word"] = "<A-S-w>",

      -- Navigation
      ["Goto Prev"] = "[",
      ["Goto Next"] = "]",
      ["Seek Up"] = "<C-Up>",
      ["Seek Down"] = "<C-Down>",
      ["Skip Region"] = "<C-x>",
      ["Remove Region"] = "<C-p>",

      -- Selection operations
      ["Select h"] = "<S-Left>",
      ["Select l"] = "<S-Right>",
      ["Select j"] = "<S-Down>",
      ["Select k"] = "<S-Up>",
      ["Select Line Down"] = "<S-J>",
      ["Select Line Up"] = "<S-K>",

      -- Word operations
      ["Select w"] = "<S-Right>",
      ["Select b"] = "<S-Left>",
      ["Select e"] = "<A-Right>",
      ["Select ge"] = "<A-Left>",

      -- Line operations
      ["Select All Words"] = "<C-S-w>",
      ["Select All Lines"] = "<C-S-l>",
      ["Select All Occurrences"] = "<C-S-a>",

      -- Visual Multi mode operations
      ["Switch Mode"] = "<Tab>",
      ["Find Next"] = "n",
      ["Find Prev"] = "N",
      ["Replace"] = "r",
      ["Surround"] = "s",
      ["Transform"] = "t",
      ["Duplicate"] = "d",
      ["Rewrite Last Search"] = "R",

      -- Alignment
      ["Align"] = "<C-a>",
      ["Align Char"] = "<C-A>",

      -- Case operations
      ["Case Conversion Menu"] = "<C-c>",
      ["Toggle Case"] = "~",
      ["To Upper Case"] = "U",
      ["To Lower Case"] = "u",

      -- Undo/Redo
      ["Undo"] = "u",
      ["Redo"] = "<C-r>",

      -- Exit
      ["Exit"] = "<Esc>",
      ["I Next"] = "<C-i>",
      ["I Prev"] = "<C-o>",
      ["A Next"] = "<C-a>",
      ["A Prev"] = "<C-A>",

      -- Mouse support
      ["Mouse Cursor"] = "<C-LeftMouse>",
      ["Mouse Word"] = "<C-RightMouse>",
      ["Mouse Column"] = "<M-C-RightMouse>",

      -- Buffer operations
      ["Tools Menu"] = "\\\\",
      ["Case Setting"] = "\\c",
      ["Toggle Whole Word"] = "\\w",
      ["Toggle Multiline"] = "\\m",
      ["Toggle Single Region"] = "\\s",
      ["Toggle Block"] = "\\<BS>",

      -- Numbers
      ["Numbers"] = "\\n",
      ["Numbers Append"] = "\\N",
      ["Zero Numbers"] = "\\0",
      ["Increase"] = "\\+",
      ["Decrease"] = "\\-",

      -- Misc
      ["Run Normal"] = "\\z",
      ["Run Last Normal"] = "\\Z",
      ["Run Visual"] = "\\v",
      ["Run Ex"] = "\\e",
      ["Run Last Ex"] = "\\E",
      ["Run Macro"] = "\\@",
      ["Invert Direction"] = "\\o",
      ["Merge Regions"] = "\\<Space>",
      ["Split Regions"] = "\\<CR>",
    }

    require("core.keymaps.vim-visual-multi")
  end,
}
