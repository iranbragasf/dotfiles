local M = {}

M.config = function()
    -- Enale options for floating windows globally
    local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
    function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
        opts = opts or {}
        opts.border = opts.border or vim.g.border
        opts.focusable = false
        return orig_util_open_floating_preview(contents, syntax, opts, ...)
    end

    vim.diagnostic.config({
        virtual_text = { source = "always" },
        float = { source = "always" },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true
    })

    -- Change diagnostic symbols in the sign column
    local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
    -- local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
    for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    end

    -- Add `:LspLog` command to open `lsp.log` file in new tab
    vim.cmd([[command! -nargs=0 LspLog execute 'lua vim.cmd("tabnew " .. vim.lsp.get_log_path())']])

    vim.cmd([[autocmd! FileType lspinfo nnoremap <buffer> q <Cmd>close<CR>]])
end

-- This hook is used to only activate the bindings after the language server
-- attaches to the current buffer.
local function on_attach(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    -- Enable completion triggered by <C-x><C-o>
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    local opts = { noremap = true, silent = true }

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'gi', '<Cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', 'gy', '<Cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', 'gr', '<Cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'gs', '<Cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '<Leader>rn', '<Cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', 'gl', '<Cmd>lua vim.diagnostic.open_float()<CR>', opts)
    buf_set_keymap('n', '[g', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']g', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<Leader>q', '<Cmd>lua vim.diagnostic.setloclist()<CR>', opts)

    -- No formatting capabilities by default
    if client.resolved_capabilities.document_formatting then
        client.resolved_capabilities.document_formatting = false
    end

    if client.resolved_capabilities.document_range_formatting then
        client.resolved_capabilities.document_range_formatting = false
    end

    -- Highlight symbol under cursor and its references
    if client.resolved_capabilities.document_highlight then
        vim.cmd([[
            augroup lsp_document_highlight
                autocmd! * <buffer>
                autocmd CursorHold,CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()
                autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
            augroup END
        ]])
    end
end

local function get_client_capabilities()
    -- Add additional capabilities supported by `nvim-cmp`
    local ok, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
    if not ok then
        vim.notify("ERROR: cmp_nvim_lsp not loaded", vim.log.levels.ERROR)
        return
    end

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = cmp_nvim_lsp.update_capabilities(capabilities)

    return capabilities
end

M.default_opts = {
    on_attach = on_attach,
    capabilities = get_client_capabilities(),
    flags = { debounce_text_changes = 150 }
}

M.server_opts = {
    ["sumneko_lua"] = function(default_opts)
        local runtime_path = vim.split(package.path, ';')
        table.insert(runtime_path, "lua/?.lua")
        table.insert(runtime_path, "lua/?/init.lua")

        default_opts.settings = {
            Lua = {
                runtime = {
                    -- Tell the language server which version of Lua you're
                    -- using (most likely LuaJIT in the case of Neovim)
                    version = 'LuaJIT',
                    -- Setup your lua path
                    path = runtime_path
                },
                diagnostics = {
                    -- Get the language server to recognize the `vim` global
                    globals = {'vim'}
                },
                workspace = {
                    -- Make the server aware of Neovim runtime files
                    library = vim.api.nvim_get_runtime_file("", true)
                },
                -- Do not send telemetry data containing a randomized but
                -- unique identifier
                telemetry = { enable = false }
            }
        }
    end,
    ["jsonls"] = function(default_opts)
        default_opts.filetypes = { "json", "jsonc" }
        default_opts.settings = {
            json = {
                schemas = require('schemastore').json.schemas()
            }
        }
    end,
}

return M
