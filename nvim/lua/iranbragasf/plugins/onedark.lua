return {
    "olimorris/onedarkpro.nvim",
    priority = 1000, -- NOTE: ensure it loads first.
    config = function()
        require("onedarkpro").setup({
            options = {
                cursorline = true,
                transparency = false,
                highlight_inactive_windows = false,
            },
        })
        vim.cmd("colorscheme onedark")
    end,
}
