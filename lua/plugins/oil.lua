return {
    "stevearc/oil.nvim",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
        "nvim-lua/plenary.nvim",
    },

    config = function()
        local oil = require("oil")
        local Path = require("plenary.path")
        local startswith = vim.startswith
        local bo = vim.bo
        local notify = vim.notify
        local ui = vim.ui
        local log = vim.log
        local map = vim.keymap.set
        local fn = vim.fn
        local cmd = vim.cmd
        local api = vim.api

        api.nvim_create_user_command("OilCheatsheet", function()
            -- yeah... noob-shit bruh...
            local lines = {
                "📁 Oil.nvim Keymap Cheatsheet",
                "--------------------------------------",
                " <CR>     → Open file/directory",
                " <C-s>    → Open in vertical split",
                " <C-x>    → Open in horizontal split",
                " <C-t>    → Open in new tab",
                " <C-p>    → Preview file",
                " <C-c>    → Close Oil buffer",
                " <C-l>    → Refresh",
                " -        → Go to parent directory",
                " _        → Open cwd",
                " `        → cd to dir",
                " ~        → tcd to dir (tab)",
                " gs       → Change sort",
                " gx       → Open with system app",
                " g.       → Toggle dotfiles",
                " g\\      → Toggle trash mode",
                "",
                " <leader>e    → Toggle sidebar",
                " <leader>nf   → New file in Oil",
                " <leader>nd   → New directory in Oil",
                " <leader>pv   → Open Oil file explorer",
            }

            cmd("new")
            api.nvim_buf_set_lines(0, 0, -1, false, lines)
            bo.buftype = "nofile"
            bo.bufhidden = "wipe"
            bo.swapfile = false
            bo.readonly = true
            bo.filetype = "oilcheatsheet"
            cmd("normal! gg")
        end, { desc = "Open Oil Keymap Cheatsheet" })

        oil.setup({
            default_file_explorer = true,

            columns = { "icon" },

            buf_options = {
                buflisted = false,
                bufhidden = "hide",
            },

            win_options = {
                wrap = false,
                signcolumn = "no",
                cursorcolumn = false,
                foldcolumn = "0",
                spell = false,
                list = false,
                conceallevel = 3,
                concealcursor = "nvic",
            },

            delete_to_trash = true,
            skip_confirm_for_simple_edits = true,
            prompt_save_on_select_new_entry = true,
            cleanup_delay_ms = 2000,

            lsp_file_methods = {
                timeout_ms = 1000,
                autosave_changes = false,
            },

            constrain_cursor = "editable",
            watch_for_changes = false,

            keymaps = {
                ["g?"] = "actions.show_help",
                ["<CR>"] = "actions.select",
                ["<C-s>"] = { "actions.select", opts = { vertical = true } },
                ["<C-x>"] = { "actions.select", opts = { horizontal = true } },
                ["<C-t>"] = { "actions.select", opts = { tab = true } },
                ["<C-p>"] = "actions.preview",
                ["<C-c>"] = "actions.close",
                ["<C-l>"] = "actions.refresh",
                ["-"] = "actions.parent",
                ["_"] = "actions.open_cwd",
                ["`"] = "actions.cd",
                ["~"] = { "actions.cd", opts = { scope = "tab" } },
                ["gs"] = "actions.change_sort",
                ["gx"] = "actions.open_external",
                ["g."] = "actions.toggle_hidden",
                ["g\\"] = "actions.toggle_trash",
            },

            use_default_keymaps = true,

            view_options = {
                show_hidden = false,
                is_hidden_file = function(name, _)
                    return startswith(name, ".")
                end,
                is_always_hidden = function(_, _)
                    return false
                end,
                natural_order = true,
                sort = {
                    { "type", "asc" },
                    { "name", "asc" },
                },
            },

            float = {
                padding = 2,
                max_width = 0,
                max_height = 0,
                border = "rounded",
                win_options = { winblend = 0 },
                preview_split = "auto",
                override = function(conf) return conf end,
            },

            preview = {
                max_width = 0.9,
                min_width = { 40, 0.4 },
                max_height = 0.9,
                min_height = { 5, 0.1 },
                border = "rounded",
                win_options = { winblend = 0 },
                update_on_cursor_moved = true,
            },

            progress = {
                max_width = 0.9,
                min_width = { 40, 0.4 },
                max_height = { 10, 0.9 },
                min_height = { 5, 0.1 },
                border = "rounded",
                minimized_border = "none",
                win_options = { winblend = 0 },
            },

            ssh = {
                border = "rounded",
            },
        })

        map("n", "<leader>fo", "<CMD>Oil<CR>", { desc = "Open parent directory in Oil" })

        map("n", "<leader>fO", function()
            require("oil").open_float()
        end, { desc = "Open Oil in floating window" })

        map("n", "<leader>fc", function()
            require("oil").open(fn.getcwd())
        end, { desc = "Open Oil in current working directory" })

        local oil_sidebar_win = nil
        map("n", "<leader>e", function()
            if oil_sidebar_win and api.nvim_win_is_valid(oil_sidebar_win) then
                api.nvim_win_close(oil_sidebar_win, true)
                oil_sidebar_win = nil
            else
                cmd("vsplit")
                cmd("wincmd h")
                cmd("vertical resize 30")
                require("oil").open()
                oil_sidebar_win = api.nvim_get_current_win()
            end
        end, { desc = "Toggle Oil sidebar" })

        map("n", "<leader>nf", function()
            if bo.filetype ~= "oil" then
                return notify("Not in oil buffer", log.levels.WARN)
            end

            ui.input({ prompt = "New file name: " }, function(input)
                if input then
                    local dir = oil.get_current_dir()
                    local path = Path:new(dir):joinpath(input):absolute()
                    cmd("edit " .. fn.fnameescape(path))
                end
            end)
        end, { desc = "Create new file in Oil" })

        map("n", "<leader>nd", function()
            if bo.filetype ~= "oil" then
                return notify("Not in oil buffer", log.levels.WARN)
            end

            ui.input({ prompt = "New directory name: " }, function(input)
                if input then
                    local dir = oil.get_current_dir()
                    local path = Path:new(dir):joinpath(input):absolute()
                    fn.mkdir(path, "p")
                    oil.open(dir)
                end
            end)
        end, { desc = "Create new directory in Oil" })

        api.nvim_create_autocmd("VimEnter", {
            callback = function()
                local arg = fn.argv(0)
                if arg ~= "" and fn.isdirectory(arg) == 1 then
                    require("oil").open()
                end
            end,
        })
    end,

    vim.keymap.set("n", "<leader>ok", "<CMD>OilCheatsheet<CR>", { desc = "Open Oil Cheatsheet" })
}

