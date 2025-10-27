local g = vim.g

return {
  "mg979/vim-visual-multi",
  branch = "master",
  init = function()
    g.VM_default_mappings = 0

    g.VM_theme = "iceblue"
    g.VM_highlight_matches = "underline"

    g.VM_live_editing = 1
    g.VM_silent_exit = 1
    g.VM_show_warnings = 1
    g.VM_case_setting = "smart"
    g.VM_use_first_cursor_in_line = 0
    g.VM_skip_shorter_lines = 0
    g.VM_extend_matches = 0
    g.VM_reselect_first = 1

    g.VM_max_find = 1000
    g.VM_max_matches = 1000

    g.VM_insert_special_keys = { "c-v", "c-a", "c-e", "c-u", "c-w", "c-r", "c-h", "c-k" }

    g.VM_maps = {

      ["Find Under"] = "<C-n>",
      ["Find Subword Under"] = "<C-n>",
      ["Select All"] = "<C-S-n>",
      ["Start Regex Search"] = "<C-/>",
      ["Add Cursor Down"] = "<A-S-j>",
      ["Add Cursor Up"] = "<A-S-k>",
      ["Add Cursor At Pos"] = "<A-S-l>",
      ["Add Cursor At Word"] = "<A-S-w>",

      ["Goto Prev"] = "[",
      ["Goto Next"] = "]",
      ["Seek Up"] = "<C-Up>",
      ["Seek Down"] = "<C-Down>",
      ["Skip Region"] = "<C-x>",
      ["Remove Region"] = "<C-p>",

      ["Select h"] = "<S-Left>",
      ["Select l"] = "<S-Right>",
      ["Select j"] = "<S-Down>",
      ["Select k"] = "<S-Up>",
      ["Select Line Down"] = "<S-J>",
      ["Select Line Up"] = "<S-K>",

      ["Select w"] = "<S-Right>",
      ["Select b"] = "<S-Left>",
      ["Select e"] = "<A-Right>",
      ["Select ge"] = "<A-Left>",

      ["Select All Words"] = "<C-S-w>",
      ["Select All Lines"] = "<C-S-l>",
      ["Select All Occurrences"] = "<C-S-a>",

      ["Switch Mode"] = "<Tab>",
      ["Find Next"] = "n",
      ["Find Prev"] = "N",
      ["Replace"] = "r",
      ["Surround"] = "s",
      ["Transform"] = "t",
      ["Duplicate"] = "d",
      ["Rewrite Last Search"] = "R",

      ["Align"] = "<C-a>",
      ["Align Char"] = "<C-A>",

      ["Case Conversion Menu"] = "<C-c>",
      ["Toggle Case"] = "~",
      ["To Upper Case"] = "U",
      ["To Lower Case"] = "u",

      ["Undo"] = "u",
      ["Redo"] = "<C-r>",

      ["Exit"] = "<Esc>",
      ["I Next"] = "<C-i>",
      ["I Prev"] = "<C-o>",
      ["A Next"] = "<C-a>",
      ["A Prev"] = "<C-A>",

      ["Mouse Cursor"] = "<C-LeftMouse>",
      ["Mouse Word"] = "<C-RightMouse>",
      ["Mouse Column"] = "<M-C-RightMouse>",

      ["Tools Menu"] = "\\\\",
      ["Case Setting"] = "\\c",
      ["Toggle Whole Word"] = "\\w",
      ["Toggle Multiline"] = "\\m",
      ["Toggle Single Region"] = "\\s",
      ["Toggle Block"] = "\\<BS>",

      ["Numbers"] = "\\n",
      ["Numbers Append"] = "\\N",
      ["Zero Numbers"] = "\\0",
      ["Increase"] = "\\+",
      ["Decrease"] = "\\-",

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
