local create_augroup = require("iranbragasf.utils").create_augroup

return {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
        require("lint").linters_by_ft = {
            javascript = { "eslint_d" },
            typescript = { "eslint_d" },
        }

        vim.api.nvim_create_autocmd(
            { "BufWritePost", "InsertLeave", "TextChanged" },
            {
                group = create_augroup("nvim-lint"),
                pattern = "*",
                callback = function()
                    if vim.g.enable_linting and vim.bo.modifiable then
                        require("lint").try_lint()
                    end
                end,
                desc = "Trigger Linting",
            }
        )
    end,
}
