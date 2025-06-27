return {
    {
        "lewis6991/gitsigns.nvim",
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local gitsigns = require("gitsigns")

            gitsigns.setup({
                signcolumn = true,
                numhl     = true,
                linehl    = false,
                word_diff = false,
                signs = {
                    add          = {hl = 'GitSignsAdd',    text = '│', numhl='GitSignsAddNr',    linehl='GitSignsAddLn'   },
                    change       = {hl = 'GitSignsChange', text = '│', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
                    delete       = {hl = 'GitSignsDelete', text = '_', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
                    topdelete    = {hl = 'GitSignsDelete', text = '‾', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
                    changedelete = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
                    untracked    = {hl = 'GitSignsAdd',    text = '┆', numhl='GitSignsAddNr',    linehl='GitSignsAddLn'   },
                },
                watch_gitdir = {
                    interval = 1000,
                    follow_files = true,
                },
                sign_priority = 6,
                update_debounce = 300,
                status_formatter = nil,
                max_file_length = 40000,
                preview_config = {
                    border = "single",
                    style = "minimal",
                    relative = "cursor",
                    row = 0,
                    col = 1,
                },
                _refresh_staged_on_update = true,
                _threaded_diff = true,
            })

            local function map(mode, l, r, opts)
                opts = opts or {}
                vim.keymap.set(mode, l, r, opts)
            end
            local cmd = vim.cmd
            local wo = vim.wo
            local notify = vim.notify
            local fn = vim.fn
            local ui = vim.ui
            local log = vim.log

            map("n", "]c", function()
                if wo.diff then
                    cmd.normal({ "]c", bang = true })
                else
                    gitsigns.nav_hunk("next")
                end
            end, { desc = "Next hunk" })

            map("n", "[c", function()
                if wo.diff then
                    cmd.normal({ "[c", bang = true })
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
            map("n", "<leader>tb", gitsigns.toggle_current_line_blame, { desc = "Toggle blame line" })
            map("n", "<leader>td", gitsigns.toggle_deleted, { desc = "Toggle deleted" })

            map("v", "<leader>hs", function()
                gitsigns.stage_hunk({ fn.line("."), fn.line("v") })
            end, { desc = "Stage hunk (visual)" })
            map("v", "<leader>hr", function()
                gitsigns.reset_hunk({ fn.line("."), fn.line("v") })
            end, { desc = "Reset hunk (visual)" })

            map({"o", "x"}, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select hunk" })

            map("n", "<leader>hi", gitsigns.preview_hunk_inline, { desc = "Preview hunk inline" })
            map("n", "<leader>hb", function()
                gitsigns.blame_line({ full = true })
            end, { desc = "Blame line (full)" })

            local function safe_git_cmd(cmd_str, desc)
                return function()
                    if fn.system('git rev-parse --git-dir 2>/dev/null'):match('%.git') then
                        cmd("tabnew | term " .. cmd_str)
                    else
                        notify("Not in a git repository", log.levels.WARN)
                    end
                end
            end

            map("n", "<leader>gs", safe_git_cmd("git status", "Git Status (tab)"), { desc = "Git Status (tab)" })
            map("n", "<leader>gc", safe_git_cmd("git commit", "Git Commit (tab)"), { desc = "Git Commit (tab)" })
            map("n", "<leader>gb", safe_git_cmd("git branch --sort=-committerdate", "Git Branches (tab)"), { desc = "Git Branches (tab)" })

            map("n", "<leader>gl", function()
                if fn.system('git rev-parse --git-dir 2>/dev/null'):match('%.git') then
                    local filepath = fn.expand("%")
                    if filepath ~= "" then
                        cmd("tabnew | term git log --oneline -- " .. fn.shellescape(filepath))
                    else
                        cmd("tabnew | term git log --oneline")
                    end
                else
                    notify("Not in a git repository", log.levels.WARN)
                end
            end, { desc = "Git Log (file, tab)" })


            map("n", "<leader>gB", function()
                if fn.system('git rev-parse --git-dir 2>/dev/null'):match('%.git') then
                    ui.input({ prompt = "Branch to checkout: " }, function(input)
                        if input and #input > 0 then
                            cmd("tabnew | term git checkout " .. fn.shellescape(input))
                        end
                    end)
                else
                    notify("Not in a git repository", log.levels.WARN)
                end
            end, { desc = "Git Checkout (tab)" })

            map("n", "<leader>gd", function()
                if fn.system('git rev-parse --git-dir 2>/dev/null'):match('%.git') then
                    ui.input({ prompt = "Diff with branch: " }, function(input)
                        if input and #input > 0 then
                            local filepath = fn.expand("%")
                            local diff_cmd = filepath ~= ""
                                and "git diff " .. fn.shellescape(input) .. " -- " .. fn.shellescape(filepath)
                                or "git diff " .. fn.shellescape(input)
                            cmd("tabnew | term " .. diff_cmd)
                        end
                    end)
                else
                    notify("Not in a git repository", log.levels.WARN)
                end
            end, { desc = "Diff with branch (tab)" })

            map("n", "<leader>gp", safe_git_cmd("git push", "Git Push (tab)"), { desc = "Git Push (tab)" })
            map("n", "<leader>gP", safe_git_cmd("git pull", "Git Pull (tab)"), { desc = "Git Pull (tab)" })
            map("n", "<leader>gf", safe_git_cmd("git fetch", "Git Fetch (tab)"), { desc = "Git Fetch (tab)" })
        end
    },
}
