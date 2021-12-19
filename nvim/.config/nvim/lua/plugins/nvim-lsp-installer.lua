local M = {}

M.config = function()
    -- Use an on_attach function to only map the following keys
    -- after the language server attaches to the current buffer
    local function on_attach(client, bufnr)
        local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
        local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

        -- Enable completion triggered by <C-x><C-o>
        buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- Mappings.
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
        buf_set_keymap('n', 'gl', '<Cmd>lua vim.lsp.diagnostic.show_line_diagnostics({border = vim.g.border, focusable = false})<CR>', opts)
        buf_set_keymap('n', '[g', '<Cmd>lua vim.lsp.diagnostic.goto_prev({popup_opts = {border = vim.g.border, focusable = false}})<CR>', opts)
        buf_set_keymap('n', ']g', '<Cmd>lua vim.lsp.diagnostic.goto_next({popup_opts = {border = vim.g.border, focusable = false}})<CR>', opts)
        buf_set_keymap('n', '<Leader>q', '<Cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
        buf_set_keymap('n', '<Leader>f', '<Cmd>lua vim.lsp.buf.formatting()<CR>', opts)

        -- Highlight the symbol and its references when holding the cursor
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

    -- Floating windows with borders
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
        vim.lsp.handlers.hover,
        { border = vim.g.border }
    )
    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
        vim.lsp.handlers.signature_help,
        { border = vim.g.border }
    )

    vim.diagnostic.config({
        virtual_text = {
            source = "if_many",
        },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
    })

    -- Change diagnostic symbols in the sign column
    -- local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
    local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
    for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    end

    -- Show line diagnostics for specific cursor position
    -- vim.cmd([[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, { focusable=false, scope="cursor" })]])

    local lsp_installer = require("nvim-lsp-installer")

    local servers = {
        "sumneko_lua",
        "jsonls",
        "tsserver",
        "yamlls",
        "bashls",
        "pyright",
        "clangd"
    }

    -- Automatically install LSP servers
    for _, name in pairs(servers) do
        local ok, server = lsp_installer.get_server(name)

        -- Check that the server is supported in nvim-lsp-installer
        if ok then
            if not server:is_installed() then
                print("Installing " .. name)
                server:install()
            end
        end
    end

    -- Add additional capabilities supported by nvim-cmp
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

    -- Register a handler that will be called for all installed servers.
    -- Alternatively, you may also register handlers on specific server
    -- instances instead (see example below).
    lsp_installer.on_server_ready(function(server)
        local default_opts = {
            on_attach = on_attach,
            capabilities = capabilities,
            flags = { debounce_text_changes = 150 }
        }

        local server_opts = {
            ["sumneko_lua"] = function()
                local runtime_path = vim.split(package.path, ';')
                table.insert(runtime_path, "lua/?.lua")
                table.insert(runtime_path, "lua/?/init.lua")

                default_opts.settings = {
                    Lua = {
                        runtime = {
                            -- Tell the language server which version of Lua
                            -- you're using (most likely LuaJIT in the case of
                            -- Neovim)
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
                        -- Do not send telemetry data containing a randomized but unique identifier
                        telemetry = { enable = false }
                    }
                }

                return default_opts
            end,
            ["jsonls"] = function()
                default_opts.filetypes = { "json", "jsonc" }
                default_opts.settings = {
                    json = {
                        schemas = require('schemastore').json.schemas()
                    }
                }

                return default_opts
            end
        }

        -- This setup() function is exactly the same as lspconfig's setup function.
        -- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
        -- We check to see if any custom server_opts exist for the LSP server,
        -- if so, load them, if not, use our default_opts
        server:setup(server_opts[server.name] and server_opts[server.name]() or default_opts)
        vim.cmd([[do User LspAttachBuffers]])
    end)
end

return M
