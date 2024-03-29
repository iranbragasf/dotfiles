local M = {}

vim.diagnostic.config({
    virtual_text = { source = "always" },
    float = { source = "always" },
    severity_sort = true
})

local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

local opts = { noremap = true, silent = true }
vim.keymap.set('n', 'gl', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[g', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']g', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<Leader>q', vim.diagnostic.setloclist, opts)

require('lspconfig.ui.windows').default_options.border = "rounded"

vim.api.nvim_create_autocmd("FileType", {
    group = "CursorLineInActiveWindow",
    pattern = 'lspinfo',
    callback = function()
        vim.api.nvim_win_set_option(0, "cursorline", true)
    end,
})

local on_attach = function(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    local buf_opts = {
        noremap = true,
        silent = true,
        buffer = bufnr,
    }

    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, buf_opts)
    -- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, buf_opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, buf_opts)
    -- vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, buf_opts)
    vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, buf_opts)
    vim.keymap.set('n', '<Leader>wa', vim.lsp.buf.add_workspace_folder, buf_opts)
    vim.keymap.set('n', '<Leader>wr', vim.lsp.buf.remove_workspace_folder, buf_opts)
    vim.keymap.set('n', '<Leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, buf_opts)
    -- vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, buf_opts)
    vim.keymap.set('n', '<Leader>rn', vim.lsp.buf.rename, buf_opts)
    vim.keymap.set('n', '<Leader>ac', vim.lsp.buf.code_action, buf_opts)
    -- vim.keymap.set('n', 'gr', vim.lsp.buf.references, buf_opts)

    if client.server_capabilities.documentHighlightProvider then
        vim.api.nvim_create_augroup('LSPDocumentHighlight', {
            clear = false
        })
        vim.api.nvim_clear_autocmds({
            buffer = bufnr,
            group = 'LSPDocumentHighlight',
        })
        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            group = 'LSPDocumentHighlight',
            buffer = bufnr,
            callback = vim.lsp.buf.document_highlight,
        })
        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            group = 'LSPDocumentHighlight',
            buffer = bufnr,
            callback = vim.lsp.buf.clear_references,
        })
    end
end

M.default_server_opts = {
    on_attach = on_attach,
    capabilities = require('cmp_nvim_lsp').default_capabilities(),
}

M.server_opts = {
    ["lua_ls"] = {
        settings = {
            Lua = {
                workspace = {
                    checkThirdParty = false,
                },
                completion = {
                    callSnippet = "Replace",
                },
            },
        },
    },
    ["jsonls"] = {
        settings = {
            json = {
                schemas = require('schemastore').json.schemas(),
                validate = { enable = true },
            }
        }
    },
    ["yamlls"] = {
        settings = {
            yaml = {
                schemaStore = {
                    enable = false,
                    url = "",
                },
                schemas = require('schemastore').yaml.schemas(),
            }
        }
    },
    ["tsserver"] = {
        init_options = {
            disableSuggestions = true,
        },
    }
}

for server_name, custom_server_opts in pairs(M.server_opts) do
    M.server_opts[server_name] = vim.tbl_extend("force", M.default_server_opts, custom_server_opts)
end

return M
