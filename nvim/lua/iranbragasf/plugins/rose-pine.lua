return {
    "rose-pine/neovim",
    name = "rose-pine",
    priority = 1000, -- NOTE: ensure it loads first.
    config = function()
        require("rose-pine").setup({
            styles = {
                bold = false,
                italic = false,
            },
            -- TODO: make these highlight groups dynamic per colorscheme.
            highlight_groups = {
                TelescopeBorder = { fg = "overlay", bg = "overlay" },
                TelescopeNormal = { fg = "subtle", bg = "overlay" },
                TelescopeSelection = { fg = "text", bg = "highlight_med" },
                TelescopeSelectionCaret = { fg = "love", bg = "highlight_med" },
                TelescopeMultiSelection = { fg = "text", bg = "highlight_high" },
                TelescopeTitle = { fg = "base", bg = "love" },
                TelescopePromptTitle = { fg = "base", bg = "pine" },
                TelescopePreviewTitle = { fg = "base", bg = "iris" },
                TelescopePromptNormal = { fg = "text", bg = "surface" },
                TelescopePromptBorder = { fg = "surface", bg = "surface" },
                IblIndent = { fg = "#313438" },
                IblWhitespace = { fg = "#313438" },
                IblScope = { fg = "#666870" },
                TreesitterContext = { link = "Normal" },
                TreesitterContextLineNumber = { link = "LineNr" },
                TreesitterContextBottom = {
                    sp = "#313438",
                    underline = true,
                },
            },
        })
        vim.cmd("colorscheme rose-pine")
    end,
}
