return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        dependencies = { "nvim-treesitter/nvim-treesitter-context" },
        -- NOTE: sets main module to use for opts.
        main = "nvim-treesitter.configs",
        opts = {
            auto_install = true,
            highlight = { enable = true },
            indent = { enable = true },
        },
    },
}
