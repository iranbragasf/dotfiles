local null_ls = require("null-ls")

local format = function(bufnr)
    vim.lsp.buf.format({
        async = false,
        buffer = bufnr,
        filter = function(client)
            return client.name == "null-ls"
        end
    })
end

vim.api.nvim_create_augroup("LspFormatting", {})

null_ls.setup({
    sources = {
        null_ls.builtins.formatting.prettierd,
        null_ls.builtins.diagnostics.eslint_d,
        null_ls.builtins.code_actions.eslint_d,
    },
    on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = "LspFormatting", buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = "LspFormatting",
                buffer = bufnr,
                callback = function()
                    format(bufnr)
                end,
            })

            vim.api.nvim_buf_create_user_command(bufnr, 'Format', function()
                format(bufnr)
            end, { nargs = 0 })
        end
    end,
    border = "rounded",
})
