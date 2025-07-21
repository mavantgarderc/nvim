local M = {}

require("colorizer").setup({
    toml = {
        rgb_fn = true,
        names = true,
        mode = "background",
        tailwind = false,
    },
})

return M
