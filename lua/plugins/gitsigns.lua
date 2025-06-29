return {
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local gitsigns = require("gitsigns")

            gitsigns.setup({
                signcolumn = true,
                numhl = true,
                linehl = false,
                word_diff = false,
                signs = {
                    add          = { hl = 'GitSignsAdd',    text = '│', numhl = 'GitSignsAddNr',    linehl = 'GitSignsAddLn' },
                    change       = { hl = 'GitSignsChange', text = '│', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
                    delete       = { hl = 'GitSignsDelete', text = '_', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
                    topdelete    = { hl = 'GitSignsDelete', text = '‾', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
                    changedelete = { hl = 'GitSignsChange', text = '~', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
                    untracked    = { hl = 'GitSignsAdd',    text = '┆', numhl = 'GitSignsAddNr',    linehl = 'GitSignsAddLn' },
                },
                watch_gitdir = {
                    interval = 1000,
                    follow_files = true,
                },
            })

            local function map(mode, lhs, rhs, opts)
                opts = opts or {}
                vim.keymap.set(mode, lhs, rhs, opts)
            end

            local function in_git_repo()
                local git_dir = vim.fn.system("git rev-parse --git-dir 2>/dev/null")
                return vim.v.shell_error == 0 and git_dir:match("%.git")
            end

            local function git_term(cmd_str)
                if in_git_repo() then
                    vim.cmd("tabnew | term " .. cmd_str)
                else
                    vim.notify("Not in a git repository", vim.log.levels.WARN)
                end
            end

            map("n", "]c", function()
                if vim.wo.diff then
                    vim.cmd.normal { args = { "]c" }, bang = true }
                else
                    gitsigns.nav_hunk("next")
                end
            end, { desc = "Next hunk" })

            map("n", "[c", function()
                if vim.wo.diff then
                    vim.cmd.normal { args = { "[c" }, bang = true }
                else
                    gitsigns.nav_hunk("prev")
                end
            end, { desc = "Prev hunk" })

            map("n", "<leader>hs", gitsigns.stage_hunk, { desc = "Stage hunk" })
            map("n", "<leader>hr", gitsigns.reset_hunk, { desc = "Reset hunk" })
            map("n", "<leader>hS", gitsigns.stage_buffer, { desc = "Stage buffer" })
            map("n", "<leader>hu", gitsigns.undo_stage_hunk, { desc = "Undo stage hunk" })
            map("n", "<leader>hR", gitsigns.reset_buffer, { desc = "Reset buffer" })
            map("n", "<leader>hp", gitsigns.preview_hunk, { desc = "Preview hunk" })
            map("n", "<leader>hi", gitsigns.preview_hunk_inline, { desc = "Inline preview" })
            map("n", "<leader>hb", function()
                gitsigns.blame_line({ full = true })
            end, { desc = "Blame line (full)" })

            map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "Toggle blame line" })
            map("n", "<leader>td", gitsigns.toggle_deleted, { desc = "Toggle deleted" })

            map("v", "<leader>hs", function()
                local s, e = vim.fn.line("v"), vim.fn.line(".")
                gitsigns.stage_hunk({ math.min(s, e), math.max(s, e) })
            end, { desc = "Stage hunk (visual)" })

            map("v", "<leader>hr", function()
                local s, e = vim.fn.line("v"), vim.fn.line(".")
                gitsigns.reset_hunk({ math.min(s, e), math.max(s, e) })
            end, { desc = "Reset hunk (visual)" })

            map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select hunk" })

            map("n", "<leader>gs", function() git_term("git status") end, { desc = "Git status" })
            map("n", "<leader>gc", function() git_term("git commit") end, { desc = "Git commit" })
            map("n", "<leader>gb", function() git_term("git branch --sort=-committerdate") end, { desc = "Git branches" })
            map("n", "<leader>gp", function() git_term("git push") end, { desc = "Git push" })
            map("n", "<leader>gP", function() git_term("git pull") end, { desc = "Git pull" })
            map("n", "<leader>gf", function() git_term("git fetch") end, { desc = "Git fetch" })

            map("n", "<leader>gl", function()
                if not in_git_repo() then
                    return vim.notify("Not in a git repository", vim.log.levels.WARN)
                end
                local filepath = vim.fn.expand("%")
                local cmd = filepath ~= "" and ("git log --oneline -- " .. vim.fn.shellescape(filepath))
                                             or "git log --oneline"
                vim.cmd("tabnew | term " .. cmd)
            end, { desc = "Git log (file)" })

            map("n", "<leader>gB", function()
                if not in_git_repo() then
                    return vim.notify("Not in a git repository", vim.log.levels.WARN)
                end
                vim.ui.input({ prompt = "Branch to checkout: " }, function(input)
                    if input and input ~= "" then
                        git_term("git checkout " .. vim.fn.shellescape(input))
                    end
                end)
            end, { desc = "Git checkout (branch)" })

            map("n", "<leader>gd", function()
                if not in_git_repo() then
                    return vim.notify("Not in a git repository", vim.log.levels.WARN)
                end
                vim.ui.input({ prompt = "Diff with branch: " }, function(input)
                    if input and input ~= "" then
                        local filepath = vim.fn.expand("%")
                        local cmd = filepath ~= ""
                            and ("git diff " .. vim.fn.shellescape(input) .. " -- " .. vim.fn.shellescape(filepath))
                            or ("git diff " .. vim.fn.shellescape(input))
                        vim.cmd("tabnew | term " .. cmd)
                    end
                end)
            end, { desc = "Git diff (branch)" })
        end,
    },
}
