local M = {}

M.config = function()
    local null_ls = require("null-ls")

    local diagnostics = null_ls.builtins.diagnostics
    local formatting = null_ls.builtins.formatting

    local formatters = {
        formatting.prettier.with({
            filetypes = {
                "javascriptreact",
                "typescript",
                "javascript",
                "typescriptreact",
                "vue",
                "css",
                "scss",
                "less",
                "html",
                "json",
                "jsonc",
                "yaml",
                "markdown",
                "graphql"
            },
            extra_args = {
                "--tab-width", "4",
                "--arrow-parens", "avoid",
                "--trailing-comma", "none"
            },
            prefer_local = "node_modules/.bin"
        }),
        formatting.prismaFmt
    }

    local linters = {
        diagnostics.eslint_d
    }

    local sources = {}

    vim.list_extend(sources, formatters)
    vim.list_extend(sources, linters)

    local function on_attach(client, bufnr)
        local format_on_save_filetypes = {
            "json",
            "jsonc",
            "yaml",
            "javascript",
            "typescript",
            "prisma"
        }

        if client.resolved_capabilities.document_formatting then
            local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")

            if vim.tbl_contains(format_on_save_filetypes, filetype) then
                vim.cmd([[
                    augroup format_on_save
                        autocmd! * <buffer>
                        autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()
                    augroup END
                ]])
            end

            -- Add `:Format` command to format current buffer
            vim.cmd([[command! -nargs=0 Format execute "lua vim.lsp.buf.formatting_sync()"]])
        end
    end

    null_ls.setup({
        sources = sources,
        on_attach = on_attach
    })

    vim.cmd([[autocmd! FileType null-ls-info nnoremap <buffer> q <Cmd>close<CR>]])
end

return M
