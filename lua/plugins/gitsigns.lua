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
                },
                watch_gitdir = {
                    interval = 1000,
                    follow_files = true,
                },
                sign_priority = 6,
                update_debounce = 100,
                status_formatter = nil,
                max_file_length = 40000,
                preview_config = {
                    border = "single",
                    style = "minimal",
                    relative = "cursor",
                    row = 0,
                    col = 1,
                },
            })

            local cmd = vim.cmd
            local wo = vim.wo
            local fn = vim.fn
            local function map(mode, l, r, opts)
                opts = opts or {}
                vim.keymap.set(mode, l, r, opts)
            end

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

            map("n", "<leader>tb", gitsigns.toggle_current_line_blame)
            map("v", "<leader>hs", function()
                gitsigns.stage_hunk({ fn.line("."), fn.line("v") })
            end, { desc = "Stage hunk (visual)" })
            map("v", "<leader>hr", function()
                gitsigns.reset_hunk({ fn.line("."), fn.line("v") })
            end, { desc = "Reset hunk (visual)" })
            map("n", "<leader>hi", gitsigns.preview_hunk_inline)
            map("n", "<leader>hb", function()
                gitsigns.blame_line({ full = true })
            end, { desc = "Blame line (full)" })

            map("n", "<leader>gs", function()
                cmd("tabnew | term git status")
            end, { desc = "Git Status (tab)" })

            map("n", "<leader>gc", function()
                cmd("tabnew | term git commit")
            end, { desc = "Git Commit (tab)" })

            map("n", "<leader>gl", function()
                local filepath = fn.expand("%")
                cmd("tabnew | term git log --oneline -- " .. filepath)
            end, { desc = "Git Log (file, tab)" })

            map("n", "<leader>gb", function()
                cmd("tabnew | term git branch --sort=-committerdate")
            end, { desc = "Git Branches (tab)" })

            map("n", "<leader>gB", function()
                cmd("tabnew | term git checkout ")
            end, { desc = "Git Checkout (tab, type branch)" })

            map("n", "<leader>gd", function()
                vim.ui.input({ prompt = "Diff with branch: " }, function(input)
                    if input and #input > 0 then
                        local filepath = fn.expand("%")
                        cmd("tabnew | term git diff " .. input .. " -- " .. filepath)
                    end
                end)
            end, { desc = "Diff with branch (tab)" })
        end,
    },
}
