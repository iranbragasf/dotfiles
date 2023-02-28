local M = {}

M.config = function()
    local null_ls_ok, null_ls = pcall(require, "null-ls")
    if not null_ls_ok then
        vim.notify("[ERROR] null-ls not loaded", vim.log.levels.ERROR)
        return
    end

    null_ls.setup({
        sources = {
            null_ls.builtins.formatting.prettier.with({
                extra_args = function(params)
                    return params.options
                    and params.options.tabSize
                    and {
                        "--tab-width",
                        params.options.tabSize,
                    }
                end,
            }),
            null_ls.builtins.diagnostics.eslint_d,
        },
        border = "rounded",
    })
end

return M
