return {
  "mbbill/undotree",
  config = function()
    local g = vim.g
    local fn = vim.fn
    local opt = vim.opt

    g.undotree_WindowLayout = 2 -- Layout: 1, 2, 3, 4
    g.undotree_SplitWidth = 40 -- Width of undotree window
    g.undotree_DiffpanelHeight = 15 -- Height of diff panel
    g.undotree_SetFocusWhenToggle = 1 -- Focus undotree when toggled
    g.undotree_ShortIndicators = 1 -- Use short time indicators
    g.undotree_HighlightChangedText = 1 -- Highlight changed text in diff
    g.undotree_HighlightChangedWithSign = 1 -- Show signs for changed lines
    g.undotree_HighlightSyntaxAdd = "DiffAdd" -- Highlight group for added lines
    g.undotree_HighlightSyntaxChange = "DiffChange" -- Highlight group for changed lines
    g.undotree_HighlightSyntaxDel = "DiffDelete" -- Highlight group for deleted lines

    g.undotree_DiffAutoOpen = 1 -- Auto open diff panel
    g.undotree_DiffCommand = "diff" -- Diff command to use

    g.undotree_TreeNodeShape = "*" -- Shape of tree nodes
    g.undotree_TreeVertShape = "|" -- Vertical line shape
    g.undotree_TreeSplitShape = "/" -- Split line shape
    g.undotree_TreeReturnShape = "\\" -- Return line shape

    -- Relative time stamps
    g.undotree_RelativeTimestamp = 1 -- Show relative timestamps

    if fn.has("persistent_undo") == 1 then
      local undodir = fn.expand("~/undodir")
      if fn.isdirectory(undodir) == 0 then
        fn.mkdir(undodir, "p")
      end
      opt.undodir = undodir
      opt.undofile = true
    end

    opt.undolevels = 10000 -- Maximum number of undos
    opt.undoreload = 10000 -- Maximum lines to save for undo on buffer reload

    require("core.keymaps.undotree")
  end,
}
