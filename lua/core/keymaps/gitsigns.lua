local M = {}

local function map(mode, lhs, rhs, opts)
    opts = opts or {}
    vim.keymap.set(mode, lhs, rhs, opts)
end
local v = vim.v
local cmd = vim.cmd
local log = vim.log
local notify = vim.notify
local wo = vim.wo
local fn = vim.fn
local ui = vim.ui


local function in_git_repo()
    local git_dir = fn.system("git rev-parse --git-dir 2>/dev/null")
    return v.shell_error == 0 and git_dir:match("%.git")
end

local function git_term(cmd_str)
    if in_git_repo() then cmd("tabnew | term " .. cmd_str)
    else notify("Not in a git repository", log.levels.WARN)
    end
end

function M.setup()
    local gitsigns = require("gitsigns")

    map("n", "]c", function()
        if wo.diff then cmd.normal { args = { "]c" }, bang = true }
        else gitsigns.nav_hunk("next")
    end end, { desc = "Next hunk" })

    map("n", "[c", function()
        if wo.diff then cmd.normal { args = { "[c" }, bang = true }
        else gitsigns.nav_hunk("prev") end
    end, { desc = "Prev hunk" })

    map("n", "<leader>ghs", gitsigns.stage_hunk,          { desc = "Stage hunk"      })
    map("n", "<leader>ghr", gitsigns.reset_hunk,          { desc = "Reset hunk"      })
    map("n", "<leader>ghS", gitsigns.stage_buffer,        { desc = "Stage buffer"    })
    map("n", "<leader>ghu", gitsigns.undo_stage_hunk,     { desc = "Undo stage hunk" })
    map("n", "<leader>ghR", gitsigns.reset_buffer,        { desc = "Reset buffer"    })
    map("n", "<leader>ghp", gitsigns.preview_hunk,        { desc = "Preview hunk"    })
    map("n", "<leader>ghi", gitsigns.preview_hunk_inline, { desc = "Inline preview"  })
    map("n", "<leader>ghb", function()
        gitsigns.blame_line({ full = true })
    end, { desc = "Blame line (full)" })

    map("n", "<leader>gb", gitsigns.toggle_current_line_blame, { desc = "Toggle blame line" })
    map("n", "<leader>gd", gitsigns.toggle_deleted,            { desc = "Toggle deleted"    })

    map("v", "<leader>ghs", function()
        local s, e = fn.line("v"), fn.line(".")
        gitsigns.stage_hunk({ math.min(s, e), math.max(s, e) })
    end, { desc = "Stage hunk (visual)" })

    map("v", "<leader>ghr", function()
        local s, e = fn.line("v"), fn.line(".")
        gitsigns.reset_hunk({ math.min(s, e), math.max(s, e) })
    end, { desc = "Reset hunk (visual)" })

    map({ "o", "x" }, "gih", ":<C-U>Gitsigns select_hunk<CR>",    { desc = "Select hunk" })

    map("n", "<leader>gS", function() git_term("git status") end, { desc = "Git status" })
    map("n", "<leader>gC", function() git_term("git commit") end, { desc = "Git commit" })
    map("n", "<leader>gb", function()
        git_term("git branch --sort=-committerdate")
    end, { desc = "Git branches" })

    map("n", "<leader>gB", function()
        if not in_git_repo() then
            return notify("Not in a git repository", log.levels.WARN)
        end
        ui.input({ prompt = "Branch to checkout: " }, function(input)
            if input and input ~= "" then
                git_term("git checkout " .. fn.shellescape(input))
            end
        end)
    end, { desc = "Git checkout (branch)" })

    map("n", "<leader>gd", function()
        if not in_git_repo() then
            return notify("Not in a git repository", log.levels.WARN)
        end
        ui.input({ prompt = "Diff with branch: " }, function(input)
            if input and input ~= "" then
                local filepath = fn.expand("%")
                local diff_cmd = filepath ~= ""
                    and ("git diff " .. fn.shellescape(input) .. " -- " .. fn.shellescape(filepath))
                    or ("git diff " .. fn.shellescape(input))
                cmd("tabnew | term " .. diff_cmd)
            end
        end)
    end, { desc = "Git diff (branch)" })
end

return M
