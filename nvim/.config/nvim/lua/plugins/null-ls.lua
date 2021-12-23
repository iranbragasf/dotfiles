local M = {}

M.config = function()
    local null_ls = require("null-ls")

    local diagnostics = null_ls.builtins.diagnostics   -- Diagnostic sources
    local formatting = null_ls.builtins.formatting     -- Formatting sources
    local code_actions = null_ls.builtins.code_actions -- Code action sources
    local hover = null_ls.builtins.hover               -- Hover sources
    local completion = null_ls.builtins.completion     -- Completion sources

    -- TODO: separate this into formatters and linters tables
    local sources = {
        formatting.prettier.with({
            filetypes = {
                "javascript",
                "javascriptreact",
                "typescript",
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
        -- formatting.shfmt.with({
        --     filetypes = { "sh", "zsh" }
        -- }),
        -- formatting.stylua,
        -- formatting.black,
        diagnostics.eslint.with({
            prefer_local = "node_modules/.bin"
        }),
        -- diagnostics.shellcheck.with({
        --     filetypes = { "sh", "zsh" }
        -- }),
        -- diagnostics.flake8
    }

    -- TODO: set format on save only for these filetypes
    -- local format_on_save_filetypes = {
    --     "html",
    --     "css",
    --     "javascript",
    --     "typescript",
    --     "json",
    --     "sh",
    --     "zsh",
    --     "lua",
    --     "python"
    -- }

    -- local function on_attach(client, bufnr)
    --     if client.resolved_capabilities.document_formatting then
    --         local filetype = vim.api.nvim_get_option(bufnr, "filetype")
    --
    --         if vim.tbl_contains(format_on_save_filetypes, filetype) then
    --             vim.cmd([[
    --                 augroup format_on_save
    --                     autocmd! * <buffer>
    --                     autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync(nil, 1000)
    --                 augroup END
    --             ]])
    --         end
    --
    --         -- Add `:Format` command to format current buffer
    --         vim.cmd([[command! -nargs=0 Format execute "lua vim.lsp.buf.formatting_sync(nil, 1000)"]])
    --
    --         -- require("plugins.nvim-lsp-installer").on_attach(client, bufnr)
    --     end
    -- end

    require("null-ls").setup({
        sources = sources,
        -- on_attach = on_attach
    })
end

return M
