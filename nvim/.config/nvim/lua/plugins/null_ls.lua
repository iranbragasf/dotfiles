local M = {}

M.config = function()
    local null_ls_ok, null_ls = pcall(require, "null-ls")
    if not null_ls_ok then
        vim.notify("[ERROR] null-ls not loaded", vim.log.levels.ERROR)
        return
    end

    local lsp_formatting = function(bufnr)
        vim.lsp.buf.format({
            filter = function(client)
                return client.name == "null-ls"
            end,
            bufnr = bufnr,
        })
    end

    vim.api.nvim_create_augroup("LspFormatting", {})

    local on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({
                group = "LspFormatting",
                buffer = bufnr
            })
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = "LspFormatting",
                buffer = bufnr,
                callback = function()
                    lsp_formatting(bufnr)
                end,
            })

            vim.api.nvim_create_user_command("Format", function()
                vim.lsp.buf.format({ bufnr = bufnr })
            end, { nargs = 0 })
        end
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
        on_attach = on_attach,
    })
end

return M
