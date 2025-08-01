local map = vim.keymap.set
local api = vim.api
local bo = vim.bo
local env = vim.env
local opt = vim.opt
local notify = vim.notify
local cmd = vim.cmd
local fn = vim.fn
local v = vim.v
local tbl_extend = vim.tbl_extend
local log = vim.log
local opts = { noremap = true, silent = true, }

-- === === ===  ===  === === ===
-- === Terminal Multiplexer  ===
-- === === ===  ===  === === ===
local function detect_multiplexer()
  if env.TMUX then
    return "tmux"
  end
  if env.ZELLIJ then
    return "zellij"
  end
  local term = env.TERM or ""
  if term:match("screen") then
    return "screen"
  elseif term:match("tmux") then
    return "tmux"
  end
  return nil
end
local function setup_multiplexer_keymaps()
  local multiplexer = detect_multiplexer()
  if multiplexer then
    map("n", "<A-h>", ":NavigateLeft<CR>", opts)
    map("n", "<A-j>", ":NavigateDown<CR>", opts)
    map("n", "<A-k>", ":NavigateUp<CR>", opts)
    map("n", "<A-l>", ":NavigateRight<CR>", opts)
  end
end
setup_multiplexer_keymaps()

-- === === ===  ===  === === ===
-- === === ===  NVIM === === ===
-- === === ===  ===  === === ===

-- === === === === === === ===
-- === === === Buffers === ===
-- === === === === === === ===
map("n", "<leader>bb", function() print(api.nvim_buf_get_name(api.nvim_get_current_buf())) end, opts)
map("n", "<leader>bl", ":ls<CR>", opts)
map("n", "<leader>bn", ":bnext<CR>", opts)
map("n", "<leader>bp", ":bprevious<CR>", opts)
map("n", "<leader>bd", ":bd<CR>", opts)

-- === === ===  ===  === === ===
-- === === === Panes === === ===
-- === === ===  ===  === === ===
map("n", "<leader>;h", "<C-w>h", opts)   -- Switch Window Left
map("n", "<leader>;l", "<C-w>l", opts)   -- Switch Window Right
map("n", "<leader>;j", "<C-w>j", opts)   -- Switch Window Down
map("n", "<leader>;k", "<C-w>k", opts)   -- Switch Window Up
map("n", "<leader>hh", "<C-w>h", opts)   -- Switch Window Left
map("n", "<leader>ll", "<C-w>l", opts)   -- Switch Window Right
map("n", "<leader>jj", "<C-w>j", opts)   -- Switch Window Down
map("n", "<leader>kk", "<C-w>k", opts)   -- Switch Window Up

map("n", "<leader>H", "<C-w>H", opts)    -- Move Window to Left
map("n", "<leader>L", "<C-w>L", opts)    -- Move Window to Right
map("n", "<leader>J", "<C-w>J", opts)    -- Move Window to Down
map("n", "<leader>K", "<C-w>K", opts)    -- Move Window to Up

map("n", "<leader>sph", ":sp<CR>", opts) -- split current window horizontally
map("n", "<leader>spv", ":vs<CR>", opts) -- split current window vertically

map("n", "<C-A-h>", ":vertical resize -1<CR>", opts)
map("n", "<C-A-l>", ":vertical resize +1<CR>", opts)
map("n", "<C-A-j>", ":resize -1<CR>", opts)
map("n", "<C-A-k>", ":resize +1<CR>", opts)
map("n", "<C-A-S-H>", ":vertical resize -5<CR>", opts)
map("n", "<C-A-S-L>", ":vertical resize +5<CR>", opts)
map("n", "<C-A-S-J>", ":resize -5<CR>", opts)
map("n", "<C-A-S-K>", ":resize +5<CR>", opts)

map("n", "<leader>T", "<C-w>T", opts) -- move current pane to a NEW tab

-- ===  === ===
-- === Tabs ===
-- ===  === ===
map("n", "<leader>tn", ":tabnew<CR>", opts)             -- New tab
map("n", "<leader>tc", ":tabclose<CR>", opts)           -- Close current tab
map("n", "<leader>to", ":tabonly<CR>", opts)            -- Close all other tabs
map("n", "<leader>tt", ":tabnext<CR>", opts)            -- Next tab
map("n", "<leader>tp", ":tabprevious<CR>", opts)        -- Previous tab

map("n", "<leader>g1", "1gt", opts)                     -- Go to tab 1
map("n", "<leader>g2", "2gt", opts)                     -- Go to tab 2
map("n", "<leader>g3", "3gt", opts)                     -- Go to tab 3
map("n", "<leader>g4", "4gt", opts)                     -- Go to tab 4
map("n", "<leader>g5", "5gt", opts)                     -- Go to tab 5
map("n", "<leader>g6", "6gt", opts)                     -- Go to tab 6
map("n", "<leader>g7", "7gt", opts)                     -- Go to tab 7
map("n", "<leader>g8", "8gt", opts)                     -- Go to tab 8
map("n", "<leader>g9", "9gt", opts)                     -- Go to tab 9
map("n", "<leader>g0", ":tablast<CR>", opts)            -- Go to last tab

map("n", "<leader>tm", ":tabmove<CR>", opts)            -- Move tab (will prompt for position)
map("n", "<leader>t<", ":tabmove -1<CR>", opts)         -- Move tab left
map("n", "<leader>t>", ":tabmove +1<CR>", opts)         -- Move tab right

map("n", "<C-t>", ":tabnew<CR>", opts)                  -- Quick new tab
map("n", "<C-w>t", ":tabnew<CR>", opts)                 -- Alternative new tab

map("n", "<leader>te", ":tabedit ", { noremap = true }) -- Edit file in new tab (no silent to see command)
map("n", "<leader>tf", ":tabfind ", { noremap = true }) -- Find and open file in new tab

map("n", "<leader>tT", ":tabnew | terminal<CR>", opts)  -- Open terminal in new tab

local function create_tab_with_file(filename) cmd("tabnew " .. filename) end

local function close_other_tabs() cmd("tabonly") end

local function close_tabs_right()
  local current_tab = fn.tabpagenr()
  local last_tab = fn.tabpagenr("$")
  for i = last_tab, current_tab + 1, -1 do
    cmd(i .. "tabclose")
  end
end

local function close_tabs_left()
  local current_tab = fn.tabpagenr()
  for i = current_tab - 1, 1, -1 do
    cmd("1tabclose")
  end
end

map("n", "<leader>tO", close_other_tabs, opts)           -- Close all other tabs (function)
map("n", "<leader>tR", close_tabs_right, opts)           -- Close tabs to the right
map("n", "<leader>tL", close_tabs_left, opts)            -- Close tabs to the left

map("n", "<leader>ti", ":tabs<CR>", opts)                -- List all tabs
map("n", "<leader>tb", ":tab split<CR>", opts)           -- Open current buffer in new tab
map("n", "<leader>td", ":tab drop ", { noremap = true }) -- Drop file in tab (no silent to see command)

map("n", "<leader>th", "1gt", opts)                      -- Go to first tab (home)
map("n", "<leader>tl", ":tablast<CR>", opts)             -- Go to last tab

-- === === ===  ===
-- === Foldings ===
-- === === ===  ===
-- Basic folding
map("n", "<leader>zff", "zf", { desc = "Create fold" })
map("v", "<leader>zff", "zf", { desc = "Create fold from selection" })
map("n", "<leader>zd", "zd", { desc = "Delete fold under cursor" })
map("n", "<leader>zD", "zD", { desc = "Delete all folds in current line" })
map("n", "<leader>zE", "zE", { desc = "Eliminate all folds" })

-- Opening folds
map("n", "zo", "zo", { desc = "Open fold under cursor" })
map("n", "zO", "zO", { desc = "Open all folds under cursor" })
map("n", "zc", "zc", { desc = "Close fold under cursor" })
map("n", "zC", "zC", { desc = "Close all folds under cursor" })
map("n", "za", "za", { desc = "Toggle fold under cursor" })
map("n", "zA", "zA", { desc = "Toggle all folds under cursor" })

-- Global fold operations
map("n", "zr", "zr", { desc = "Reduce fold level (open one level)" })
map("n", "zR", "zR", { desc = "Open all folds" })
map("n", "zm", "zm", { desc = "Fold more (close one level)" })
map("n", "zM", "zM", { desc = "Close all folds" })

-- Fold navigation
map("n", "zj", "zj", { desc = "Move to next fold" })
map("n", "zk", "zk", { desc = "Move to previous fold" })
map("n", "[z", "[z", { desc = "Move to start of current fold" })
map("n", "]z", "]z", { desc = "Move to end of current fold" })

-- Fold view operations
map("n", "zv", "zv", { desc = "View cursor line (open folds)" })
map("n", "zx", "zx", { desc = "Update folds" })
map("n", "zX", "zX", { desc = "Undo manually opened/closed folds" })

-- Fold level operations
map("n", "z1", function() opt.foldlevel = 1 end, { desc = "Set fold level to 1" })
map("n", "z2", function() opt.foldlevel = 2 end, { desc = "Set fold level to 2" })
map("n", "z3", function() opt.foldlevel = 3 end, { desc = "Set fold level to 3" })
map("n", "z4", function() opt.foldlevel = 4 end, { desc = "Set fold level to 4" })
map("n", "z5", function() opt.foldlevel = 5 end, { desc = "Set fold level to 5" })
map("n", "z6", function() opt.foldlevel = 6 end, { desc = "Set fold level to 6" })
map("n", "z7", function() opt.foldlevel = 7 end, { desc = "Set fold level to 7" })
map("n", "z8", function() opt.foldlevel = 8 end, { desc = "Set fold level to 8" })
map("n", "z9", function() opt.foldlevel = 9 end, { desc = "Set fold level to 9" })
map("n", "z0", function() opt.foldlevel = 0 end, { desc = "Set fold level to 0" })

-- Quick fold level adjustments
map("n", "<leader>z+", "zr", { desc = "Reduce fold level (open one level)" })
map("n", "<leader>z-", "zm", { desc = "Fold more (close one level)" })
map("n", "<leader>zR", "zR", { desc = "Open all folds" })
map("n", "<leader>zM", "zM", { desc = "Close all folds" })

-- Fold method switching
map("n", "<leader>zmi", function() opt.foldmethod = "indent" end, { desc = "Set fold method to indent" })
map("n", "<leader>zms", function() opt.foldmethod = "syntax" end, { desc = "Set fold method to syntax" })
map("n", "<leader>zmm", function() opt.foldmethod = "manual" end, { desc = "Set fold method to manual" })
map("n", "<leader>zme", function() opt.foldmethod = "expr" end, { desc = "Set fold method to expr" })
map("n", "<leader>zmk", function() opt.foldmethod = "marker" end, { desc = "Set fold method to marker" })
map("n", "<leader>zmd", function() opt.foldmethod = "diff" end, { desc = "Set fold method to diff" })

-- Toggle fold column
map("n", "<leader>zfc", function()
  local current = opt.foldcolumn:get()
  if current == "0" then
    opt.foldcolumn = "4"
    notify("Fold column enabled")
  else
    opt.foldcolumn = "0"
    notify("Fold column disabled")
  end
end, { desc = "Toggle fold column" })

-- Show fold info
map("n", "<leader>zi", function()
  local foldlevel  = opt.foldlevel:get()
  local foldmethod = opt.foldmethod:get()
  local foldcolumn = opt.foldcolumn:get()
  local foldenable = opt.foldenable:get()

  local info       = string.format(
    "Fold Info:\n• Method: %s\n• Level: %d\n• Column: %s\n• Enabled: %s",
    foldmethod, foldlevel, foldcolumn, foldenable and "Yes" or "No"
  )
  notify(info)
end, { desc = "Show fold info" })

-- Toggle folding on/off
map("n", "<leader>zt", function()
  opt.foldenable = not opt.foldenable:get()
  local status = opt.foldenable:get() and "enabled" or "disabled"
  notify("Folding " .. status)
end, { desc = "Toggle folding" })

-- Fold all functions (for programming languages)
-- map("n", "<leader>zff", function()
--   cmd("normal! zE")  -- Clear existing folds
--   cmd("g/^\\s*function\\|^\\s*def\\|^\\s*class/,/^}/fold")
-- end, { desc = "Fold all functions" })

-- Fold all comments
map("n", "<leader>zcc", function()
  cmd("normal! zE") -- Clear existing folds
  cmd("g/^\\s*\\/\\*\\|^\\s*\\/\\/\\|^\\s*#\\|^\\s*\"/,/\\*\\/\\|$/fold")
end, { desc = "Fold all comments" })

-- Save and restore fold state
map("n", "<leader>zs", function()
  cmd("mkview")
  notify("Fold state saved")
end, { desc = "Save fold state" })

map("n", "<leader>zl", function()
  cmd("loadview")
  notify("Fold state loaded")
end, { desc = "Load fold state" })

-- === === ===  === === ===
-- === === Markings === ===
-- === === ===  === === ===
-- Set marks (default: m{a-zA-Z})
-- m{a-z} - file-local marks
-- m{A-Z} - global marks (across files)
-- These are native and don't need remapping

-- Jump to marks (default: '{mark} and `{mark})
-- '{mark} - jump to line of mark
-- `{mark} - jump to exact position (line and column)
-- These are native and don't need remapping

-- Quick mark navigation
map("n", "<leader>m", "", { desc = "Mark operations" })

-- Set commonly used marks with descriptive names
map("n", "<leader>mm", "mM", tbl_extend("force", opts, { desc = "Set mark M (Main)" }))
map("n", "<leader>mt", "mT", tbl_extend("force", opts, { desc = "Set mark T (Top)" }))
map("n", "<leader>mb", "mB", tbl_extend("force", opts, { desc = "Set mark B (Bottom)" }))
map("n", "<leader>ms", "mS", tbl_extend("force", opts, { desc = "Set mark S (Section)" }))
map("n", "<leader>mf", "mF", tbl_extend("force", opts, { desc = "Set mark F (Function)" }))

-- Quick jump to commonly used marks
map("n", "<leader>jm", "'M", tbl_extend("force", opts, { desc = "Jump to mark M" }))
map("n", "<leader>jt", "'T", tbl_extend("force", opts, { desc = "Jump to mark T" }))
map("n", "<leader>jb", "'B", tbl_extend("force", opts, { desc = "Jump to mark B" }))
map("n", "<leader>js", "'S", tbl_extend("force", opts, { desc = "Jump to mark S" }))
map("n", "<leader>jf", "'F", tbl_extend("force", opts, { desc = "Jump to mark F" }))

-- Jump to exact position of marks
map("n", "<leader>gm", "`M", tbl_extend("force", opts, { desc = "Go to mark M (exact)" }))
map("n", "<leader>gt", "`T", tbl_extend("force", opts, { desc = "Go to mark T (exact)" }))
map("n", "<leader>gb", "`B", tbl_extend("force", opts, { desc = "Go to mark B (exact)" }))
map("n", "<leader>gs", "`S", tbl_extend("force", opts, { desc = "Go to mark S (exact)" }))
map("n", "<leader>gf", "`F", tbl_extend("force", opts, { desc = "Go to mark F (exact)" }))

-- MARK MANAGEMENT
-- ============================================================================
-- List all marks
map("n", "<leader>ml", ":marks<CR>", tbl_extend("force", opts, { desc = "List all marks" }))

-- Delete marks
map("n", "<leader>md", ":delmarks<CR>", { desc = "Delete marks (specify which)" })
map("n", "<leader>mD", ":delmarks!<CR>", tbl_extend("force", opts, { desc = "Delete all lowercase marks" }))

-- Clear specific mark ranges
map("n", "<leader>mca", ":delmarks a-z<CR>", tbl_extend("force", opts, { desc = "Clear all local marks" }))
map("n", "<leader>mcA", ":delmarks A-Z<CR>", tbl_extend("force", opts, { desc = "Clear all global marks" }))
map("n", "<leader>mc0", ":delmarks 0-9<CR>", tbl_extend("force", opts, { desc = "Clear all numbered marks" }))

-- automatics; don't need maps; documented for reference:
-- ` - position before latest jump
-- ' - position before latest jump (line only)
-- " - position when last exiting current buffer
-- ^ - position of last insertion
-- . - position of last change
-- [ - start of last change or yank
-- ] - end of last change or yank
-- < - start of last visual selection
-- > - end of last visual selection

-- Enhanced navigation for automatic marks
map("n", "<leader>j`", "``", tbl_extend("force", opts, { desc = "Jump to last jump position" }))
map("n", "<leader>j'", "''", tbl_extend("force", opts, { desc = "Jump to last jump line" }))
map("n", "<leader>j\"", "`\"", tbl_extend("force", opts, { desc = "Jump to last exit position" }))
map("n", "<leader>j^", "`^", tbl_extend("force", opts, { desc = "Jump to last insert position" }))
map("n", "<leader>j.", "`.", tbl_extend("force", opts, { desc = "Jump to last change position" }))
map("n", "<leader>j[", "`[", tbl_extend("force", opts, { desc = "Jump to change/yank start" }))
map("n", "<leader>j]", "`]", tbl_extend("force", opts, { desc = "Jump to change/yank end" }))
map("n", "<leader>j<", "`<", tbl_extend("force", opts, { desc = "Jump to visual selection start" }))
map("n", "<leader>j>", "`>", tbl_extend("force", opts, { desc = "Jump to visual selection end" }))

-- Jump list navigation (enhanced)
map("n", "<C-o>", "<C-o>", tbl_extend("force", opts, { desc = "Jump to older position" }))
map("n", "<C-i>", "<C-i>", tbl_extend("force", opts, { desc = "Jump to newer position" }))
map("n", "<leader>jo", ":jumps<CR>", tbl_extend("force", opts, { desc = "Show jump list" }))

-- Change list navigation
map("n", "g;", "g;", tbl_extend("force", opts, { desc = "Go to older change" }))
map("n", "g,", "g,", tbl_extend("force", opts, { desc = "Go to newer change" }))
map("n", "<leader>jc", ":changes<CR>", tbl_extend("force", opts, { desc = "Show change list" }))

-- Function to set a mark and provide feedback
local function set_mark_with_feedback(mark)
  cmd("mark " .. mark)
  notify("Mark " .. mark .. " set at line " .. fn.line("."), log.levels.INFO)
end

-- Function to jump to mark with feedback
local function jump_to_mark_with_feedback(mark)
  local pos = fn.getpos("'" .. mark)
  if pos[2] == 0 then
    notify("Mark " .. mark .. " not set", log.levels.WARN)
  else
    cmd("normal! '" .. mark)
    notify("Jumped to mark " .. mark .. " at line " .. pos[2], log.levels.INFO)
  end
end

-- Enhanced mark setting with feedback
map("n", "<leader>mM", function() set_mark_with_feedback("M") end, { desc = "Set mark M with feedback" })
map("n", "<leader>mT", function() set_mark_with_feedback("T") end, { desc = "Set mark T with feedback" })
map("n", "<leader>mB", function() set_mark_with_feedback("B") end, { desc = "Set mark B with feedback" })

-- Enhanced mark jumping with feedback
map("n", "<leader>JM", function() jump_to_mark_with_feedback("M") end, { desc = "Jump to mark M with feedback" })
map("n", "<leader>JT", function() jump_to_mark_with_feedback("T") end, { desc = "Jump to mark T with feedback" })
map("n", "<leader>JB", function() jump_to_mark_with_feedback("B") end, { desc = "Jump to mark B with feedback" })

-- Set marks in visual mode
map("v", "<leader>mm", "mM", tbl_extend("force", opts, { desc = "Set mark M (visual)" }))
map("v", "<leader>mt", "mT", tbl_extend("force", opts, { desc = "Set mark T (visual)" }))
map("v", "<leader>mb", "mB", tbl_extend("force", opts, { desc = "Set mark B (visual)" }))

-- Project bookmarks using capital letters
map("n", "<leader>bm", "mM", tbl_extend("force", opts, { desc = "Bookmark: Main file" }))
map("n", "<leader>bc", "mC", tbl_extend("force", opts, { desc = "Bookmark: Config file" }))
map("n", "<leader>bt", "mT", tbl_extend("force", opts, { desc = "Bookmark: Test file" }))
map("n", "<leader>br", "mR", tbl_extend("force", opts, { desc = "Bookmark: README file" }))
-- map("n", "<leader>bd", "mD", tbl_extend("force", opts, { desc = "Bookmark: Documentation" }))

-- Jump to project bookmarks
map("n", "<leader>Bm", "'M", tbl_extend("force", opts, { desc = "Go to Main bookmark" }))
map("n", "<leader>Bc", "'C", tbl_extend("force", opts, { desc = "Go to Config bookmark" }))
map("n", "<leader>Bt", "'T", tbl_extend("force", opts, { desc = "Go to Test bookmark" }))
map("n", "<leader>Br", "'R", tbl_extend("force", opts, { desc = "Go to README bookmark" }))
map("n", "<leader>Bd", "'D", tbl_extend("force", opts, { desc = "Go to Documentation bookmark" }))

-- numbered marks (0-9) - for recent files
-- Note: Numbered marks 0-9 are automatically set by Vim:
-- 0 - position when Vim was last exited
-- 1-9 - positions when files were last exited
-- These don't need maps but can be jumped to with '0-'9
-- Quick access to recent file positions
map("n", "<leader>j0", "'0", tbl_extend("force", opts, { desc = "Jump to last exit position" }))
map("n", "<leader>j1", "'1", tbl_extend("force", opts, { desc = "Jump to recent file 1" }))
map("n", "<leader>j2", "'2", tbl_extend("force", opts, { desc = "Jump to recent file 2" }))
map("n", "<leader>j3", "'3", tbl_extend("force", opts, { desc = "Jump to recent file 3" }))

-- Mark the current position before big operations
map("n", "<leader>m.", "m.", tbl_extend("force", opts, { desc = "Mark current position" }))
map("n", "<leader>j.", "'.", tbl_extend("force", opts, { desc = "Return to marked position" }))

-- Mark and return pattern
map("n", "<leader>mr", "m'", tbl_extend("force", opts, { desc = "Mark for return" }))
map("n", "<leader>jr", "''", tbl_extend("force", opts, { desc = "Return to mark" }))

-- Save position before search
map("n", "/", "m'/", tbl_extend("force", opts, { desc = "Search (mark position)" }))
map("n", "?", "m'?", tbl_extend("force", opts, { desc = "Search backwards (mark position)" }))

-- If using telescope.nvim, you might want these
map("n", "<leader>fm", "<cmd>Telescope marks<CR>", { desc = "Find marks with Telescope" })

-- useful commands
api.nvim_create_user_command("ShowMarks", "marks", { desc = "Show all marks" })
api.nvim_create_user_command("ClearMarks", "delmarks a-z", { desc = "Clear all local marks" })
api.nvim_create_user_command("ClearAllMarks", "delmarks!", { desc = "Clear all marks" })

-- Command to show mark info
api.nvim_create_user_command("MarkInfo", function()
  local marks = fn.getmarklist()
  local buf_marks = fn.getmarklist(fn.bufnr())
  print("Global marks: " .. #marks)
  print("Buffer marks: " .. #buf_marks)
  cmd("marks")
end, { desc = "Show mark information" })

api.nvim_create_augroup("MarkHighlight", { clear = true })
api.nvim_create_autocmd("ModeChanged", {
  group = "MarkHighlight",
  pattern = "*:n",
  callback = function()
  end,
})

api.nvim_create_autocmd("VimLeave", {
  group = "MarkHighlight",
  callback = function()
  end,
})
