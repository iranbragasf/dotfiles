local null_ls = require("null-ls")

vim.api.nvim_create_augroup("LspFormatting", {})

null_ls.setup({
    sources = {
        null_ls.builtins.diagnostics.eslint,
        null_ls.builtins.formatting.prettier
        -- null_ls.builtins.formatting.prettier.with({
        --     extra_args = function(params)
        --         return params.options
        --         and params.options.tabSize
        --         and {
        --             "--tab-width",
        --             params.options.tabSize,
        --         }
        --     end,
        -- }),
    },
    on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({
                group = "LspFormatting",
                buffer = bufnr
            })
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = "LspFormatting",
                buffer = bufnr,
                callback = function()
                    vim.lsp.buf.format({
                        async = false,
                        buffer = bufnr,
                    })
                end,
            })

            -- Create a command `:Format` local to the LSP buffer
            vim.api.nvim_buf_create_user_command(bufnr, 'Format', function()
                vim.lsp.buf.format({
                    async = false,
                    bufnr = bufnr
                })
            end, { nargs = 0 })
        end
    end,
    border = "rounded",
})
