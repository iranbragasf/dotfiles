return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        -- NOTE: sets main module to use for opts.
        dependencies = {
            "nvim-treesitter/nvim-treesitter-context",
        },
        main = "nvim-treesitter.configs",
        opts = {
            auto_install = true,
            highlight = { enable = true },
            indent = { enable = true },
        },
    },
}
