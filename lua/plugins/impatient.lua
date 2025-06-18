return {
    "lewis6991/impatient.nvim",
    priority = 1000, -- Ensures early loading
    config = function()
        vim.g.impatient = {
            enable_profile = 1,
            cache_size = 1000,
            cache_persist = 1,
            cache_path = vim.fn.stdpath("cache") .. "/impatient",
            debug = 0,
        }

        local status_ok, impatient = pcall(require, "impatient")
        if not status_ok then
            vim.notify("impatient.nvim failed to load", vim.log.levels.ERROR)
            return
        end

        vim.api.nvim_create_user_command("ShowStartupStats", function()
            local stats = impatient.get_stats()
            if not stats then
                vim.notify("Startup statistics not available", vim.log.levels.WARN)
                return
            end

            local msg = string.format(
                "Startup time: %.3fms (%.1fx faster)\nCached modules: %d",
                stats.startup_time * 1000,
                stats.speed_ratio,
                stats.cached_modules
            )

            vim.notify(msg, vim.log.levels.INFO, {
                title = "impatient.nvim",
                timeout = 5000,
            })
        end, {})

        vim.api.nvim_create_user_command("ShowModuleStats", function()
            local stats = impatient.get_stats()
            if not stats then
                vim.notify("Module statistics not available", vim.log.levels.WARN)
                return
            end

            local buf = vim.api.nvim_create_buf(false, true)
            vim.api.nvim_buf_set_name(buf, "impatient-stats")

            -- Add header
            local lines = {
                "IMPATIENT.NVIM MODULE STATISTICS",
                "=================================",
                string.format("Total startup time: %.3fms", stats.startup_time * 1000),
                string.format("Speed ratio: %.1fx faster", stats.speed_ratio),
                "---------------------------------",
                "Module Name" .. string.rep(" ", 45) .. "Load Time (ms)",
            }

            -- Add module data sorted by load time
            local sorted_modules = {}
            for name, time in pairs(stats.modules) do
                table.insert(sorted_modules, { name = name, time = time })
            end

            table.sort(sorted_modules, function(a, b) return a.time > b.time end)

            for _, mod in ipairs(sorted_modules) do
                local formatted_time = string.format("%.3f", mod.time * 1000)
                local padding = string.rep(" ", 55 - #mod.name)
                table.insert(lines, mod.name .. padding .. formatted_time)
            end

            vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

            vim.api.nvim_command("vsplit | buffer " .. buf)
            vim.bo[buf].modifiable = false
            vim.bo[buf].filetype = "impatient-stats"
        end, {})
    end,
}
