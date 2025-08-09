return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        dependencies = {
            {
                "nvim-treesitter/nvim-treesitter-context",
                config = function()
                    local treesitter_context = require("treesitter-context")
                    treesitter_context.setup({
                        multiwindow = true,
                        max_lines = 5,
                        multiline_threshold = 1,
                        trim_scope = "inner",
                        mode = "topline",
                    })
                    vim.keymap.set("n", "[c", function()
                        treesitter_context.go_to_context(vim.v.count1)
                    end, {
                        silent = true,
                        desc = "Jump to context",
                    })
                end,
            },
        },
        -- NOTE: sets main module to use for opts.
        main = "nvim-treesitter.configs",
        opts = {
            auto_install = true,
            highlight = { enable = true },
            indent = { enable = true },
        },
    },
}
