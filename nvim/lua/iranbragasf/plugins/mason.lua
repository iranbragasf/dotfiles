return {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
        { "mason-org/mason.nvim", opts = {} },
        {
            "WhoIsSethDaniel/mason-tool-installer.nvim",
            opts = {
                ensure_installed = {
                    "lua_ls",
                    "stylua",
                    "html",
                    "cssls",
                    "ts_ls",
                    "eslint_d",
                    "prettierd",
                    "jsonls",
                },
                auto_update = true,
            }
        },
        "neovim/nvim-lspconfig",
    },
    opts = {}
}
