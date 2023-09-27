local null_ls = require("null-ls")

vim.api.nvim_create_augroup("LspFormatting", {})

null_ls.setup({
    sources = {
        null_ls.builtins.formatting.prettier,
    },
    on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = "LspFormatting", buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = "LspFormatting",
                buffer = bufnr,
                callback = function()
                    vim.lsp.buf.format({
                        async = false,
                        buffer = bufnr,
                        filter = function(client)
                            return client.name == "null-ls"
                        end
                    })
                end,
            })

            -- Create a command `:Format` local to the LSP buffer
            vim.api.nvim_buf_create_user_command(bufnr, 'Format', function()
                vim.lsp.buf.format({
                    async = false,
                    bufnr = bufnr,
                    filter = function(client)
                        return client.name == "null-ls"
                    end
                })
            end, { nargs = 0 })
        end
    end,
    border = "rounded",
})
