return {
    "neovim/nvim-lspconfig",
    dependencies = { "b0o/schemastore.nvim", },
    config = function()
        vim.keymap.set("n", "[g", function() vim.diagnostic.jump({ count = -1 }) end, { noremap = true })
        vim.keymap.set("n", "]g", function() vim.diagnostic.jump({ count = 1 }) end, { noremap = true })
        vim.keymap.set("n", "[G", function()
            local diagnostics = vim.diagnostic.get(0)
            if #diagnostics > 0 then
                local first = diagnostics[1]
                vim.api.nvim_win_set_cursor(0, { first.lnum + 1, first.col })
            end
        end)
        vim.keymap.set("n", "]G", function()
            local diagnostics = vim.diagnostic.get(0)
            if #diagnostics > 0 then
                local last = diagnostics[#diagnostics]
                vim.api.nvim_win_set_cursor(0, { last.lnum + 1, last.col })
            end
        end)
        vim.keymap.set("n", "gl", vim.diagnostic.open_float, { noremap = true })

        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
            callback = function(event)
                local map = function(keys, func, mode)
                    mode = mode or "n"
                    vim.keymap.set(mode, keys, func, { buffer = event.buf })
                end

                map("<Leader>rn", vim.lsp.buf.rename)
                map("<Leader>ac", vim.lsp.buf.code_action, { "n", "x" })
                -- map("gr", require("telescope.builtin").lsp_references)
                -- map("gi", require("telescope.builtin").lsp_implementations)
                -- map("gd", require("telescope.builtin").lsp_definitions)
                map("gr", vim.lsp.buf.references)
                map("gi", vim.lsp.buf.implementation)
                map("gd", vim.lsp.buf.definition)
                map("gD", vim.lsp.buf.declaration)
                -- map("<Leader>o", require("telescope.builtin").lsp_document_symbols)
                -- map("<Leader>s", require("telescope.builtin").lsp_dynamic_workspace_symbols)
                -- map("gy", require("telescope.builtin").lsp_type_definitions)
                map("<Leader>o", vim.lsp.buf.document_symbol)
                map("<Leader>s", vim.lsp.buf.workspace_symbol)
                map("gy", vim.lsp.buf.type_definition)
                map("<C-k>", vim.lsp.buf.signature_help, { "i", "s", "n" })

                -- NOTE: Highlight references of the word under the cursor when
                -- it rests there for a little while.
                local client = vim.lsp.get_client_by_id(event.data.client_id)
                if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
                    local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
                    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                        buffer = event.buf,
                        group = highlight_augroup,
                        callback = vim.lsp.buf.document_highlight,
                    })

                    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                        buffer = event.buf,
                        group = highlight_augroup,
                        callback = vim.lsp.buf.clear_references,
                    })

                    vim.api.nvim_create_autocmd("LspDetach", {
                        group = vim.api.nvim_create_augroup("lsp-detach", { clear = true }),
                        callback = function(event2)
                            vim.lsp.buf.clear_references()
                            vim.api.nvim_clear_autocmds { group = "lsp-highlight", buffer = event2.buf }
                        end,
                    })
                end
            end,
        })

        vim.diagnostic.config({
            virtual_text = true,
            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = "󰅚 ",
                    [vim.diagnostic.severity.WARN] = "󰀪 ",
                    [vim.diagnostic.severity.INFO] = "󰋽 ",
                    [vim.diagnostic.severity.HINT] = "󰌶 ",
                },
            } or true,
            float = { source = true },
            severity_sort = true,
        })
    end
}
