return {
    "neovim/nvim-lspconfig",
    dependencies = { "b0o/schemastore.nvim" },
    config = function()
        vim.keymap.set("n", "[g", function() vim.diagnostic.jump({ count = -1 }) end, { noremap = true })
        vim.keymap.set("n", "]g", function() vim.diagnostic.jump({ count = 1 }) end, { noremap = true })
        vim.keymap.set("n", "[G", function()
            local diagnostics = vim.diagnostic.get(0)
            if #diagnostics == 0 then
                vim.notify("No more valid diagnostics to move to", vim.log.levels.WARN)
                return
            end
            table.sort(diagnostics, function(a, b)
                if a.lnum == b.lnum then
                    return a.col < b.col
                end
                return a.lnum < b.lnum
            end)
            local first = diagnostics[1]
            vim.api.nvim_win_set_cursor(0, { first.lnum + 1, first.col })
        end)
        vim.keymap.set("n", "]G", function()
            local diagnostics = vim.diagnostic.get(0)
            if #diagnostics == 0 then
                vim.notify("No more valid diagnostics to move to", vim.log.levels.WARN)
                return
            end
            table.sort(diagnostics, function(a, b)
                if a.lnum == b.lnum then
                    return a.col < b.col
                end
                return a.lnum < b.lnum
            end)
            local last = diagnostics[#diagnostics]
            vim.api.nvim_win_set_cursor(0, { last.lnum + 1, last.col })
        end)
        vim.keymap.set("n", "gl", vim.diagnostic.open_float, { noremap = true })
        vim.keymap.set("n", "<Leader>m", function()
            vim.diagnostic.setqflist({ title = "Workspace Diagnostics" })
        end, { noremap = true })

        vim.diagnostic.config({
            virtual_text = true,
            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = "󰅚 ",
                    [vim.diagnostic.severity.WARN] = "󰀪 ",
                    [vim.diagnostic.severity.INFO] = "󰋽 ",
                    [vim.diagnostic.severity.HINT] = "󰌶 ",
                },
            },
            float = { source = true },
            severity_sort = true,
        })

        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
            callback = function(event)
                vim.keymap.set("n", "<Leader>rn", vim.lsp.buf.rename, { buffer = event.buf })
                vim.keymap.set({ "n", "x" }, "<Leader>ac", vim.lsp.buf.code_action,  { buffer = event.buf })
                vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = event.buf })
                vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { buffer = event.buf })
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = event.buf })
                vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = event.buf })
                vim.keymap.set("n", "<Leader>o", vim.lsp.buf.document_symbol, { buffer = event.buf })
                vim.keymap.set("n", "gy", vim.lsp.buf.type_definition, { buffer = event.buf })
                vim.keymap.set("n", "<C-s>", vim.lsp.buf.signature_help, { buffer = event.buf })

                local client = vim.lsp.get_client_by_id(event.data.client_id)
                if not client then return end

                if client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
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

                -- if client:supports_method('textDocument/completion') then
                --     vim.lsp.completion.enable(true, client.id, event.buf, { autotrigger = true })
                --     vim.keymap.set("i", "<C-Space>", vim.lsp.completion.get, { buffer = event.buf })
                -- end
            end,
        })
    end
}
