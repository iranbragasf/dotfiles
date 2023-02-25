local M = {}

M.config = function()
    vim.diagnostic.config({
        virtual_text = {
            source = "always"
        },
        float = {
            source = "always",
            focusable = false
        },
        severity_sort = true
    })

    local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
    -- local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
    for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    end

    local opts = { noremap = true, silent = true }
    vim.keymap.set('n', 'gl', vim.diagnostic.open_float, opts)
    vim.keymap.set('n', '[g', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', ']g', vim.diagnostic.goto_next, opts)
    vim.keymap.set('n', '<Leader>q', vim.diagnostic.setloclist, opts)
end

local function on_attach(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    local buf_opts = {
        noremap = true,
        silent = true,
        buffer = bufnr,
    }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, buf_opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, buf_opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, buf_opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, buf_opts)
    vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, buf_opts)
    vim.keymap.set('n', '<Leader>wa', vim.lsp.buf.add_workspace_folder, buf_opts)
    vim.keymap.set('n', '<Leader>wr', vim.lsp.buf.remove_workspace_folder, buf_opts)
    vim.keymap.set('n', '<Leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, buf_opts)
    vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, buf_opts)
    vim.keymap.set('n', '<Leader>rn', vim.lsp.buf.rename, buf_opts)
    vim.keymap.set('n', '<Leader>ac', vim.lsp.buf.code_action, buf_opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, buf_opts)

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

local capabilities = require("plugins.nvim-cmp").capabilities

local handlers =  {
    ["textDocument/hover"] =  vim.lsp.with(vim.lsp.handlers.hover, { focusable = false }),
    ["textDocument/signatureHelp"] =  vim.lsp.with(vim.lsp.handlers.signature_help, { focusable = false }),
}

M.default_opts = {
    on_attach = on_attach,
    capabilities = capabilities,
    handlers = handlers
}

M.server_opts = {
    ["lua_ls"] = {
        settings = {
            Lua = {
                runtime = {
                    version = 'LuaJIT',
                },
                diagnostics = {
                    globals = {'vim'},
                },
                workspace = {
                    library = vim.api.nvim_get_runtime_file("", true),
                },
                telemetry = {
                    enable = false,
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
    }
}

return M
