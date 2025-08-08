local create_augroup = require("iranbragasf.utils").create_augroup

---@param first_or_last "first" | "last"
local jump_to_first_or_last_diagnostic = function(first_or_last)
    if first_or_last ~= "first" and first_or_last ~= "last" then
        error(
            ("Invalid argument: '%s'. Expected 'first' or 'last'."):format(
                tostring(first_or_last)
            )
        )
    end
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
    if first_or_last == "first" then
        local first = diagnostics[1]
        vim.api.nvim_win_set_cursor(0, { first.lnum + 1, first.col })
    elseif first_or_last == "last" then
        local last = diagnostics[#diagnostics]
        vim.api.nvim_win_set_cursor(0, { last.lnum + 1, last.col })
    end
end

return {
    "neovim/nvim-lspconfig",
    dependencies = { "b0o/schemastore.nvim" },
    config = function()
        vim.keymap.set("n", "[g", function()
            vim.diagnostic.jump({ count = -1 })
        end, {
            noremap = true,
            desc = "Jump to the previous diagnostic in the current buffer",
        })
        vim.keymap.set("n", "]g", function()
            vim.diagnostic.jump({ count = 1 })
        end, {
            noremap = true,
            desc = "Jump to the next diagnostic in the current buffer",
        })

        vim.keymap.set("n", "[G", function()
            jump_to_first_or_last_diagnostic("first")
        end, {
            noremap = true,
            desc = "Jump to the first diagnostic in the current buffer",
        })
        vim.keymap.set("n", "]G", function()
            jump_to_first_or_last_diagnostic("last")
        end, {
            noremap = true,
            desc = "Jump to the last diagnostic in the current buffer",
        })
        vim.keymap.set("n", "gl", vim.diagnostic.open_float, {
            noremap = true,
            desc = "Show diagnostics in a float window",
        })
        vim.keymap.set("n", "<Leader>m", function()
            vim.diagnostic.setqflist({ title = "Workspace Diagnostics" })
        end, { noremap = true, desc = "List all workspace diagnostics" })

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
            group = create_augroup("lsp-attach"),
            callback = function(event)
                vim.keymap.set(
                    "n",
                    "<Leader>rn",
                    vim.lsp.buf.rename,
                    { buffer = event.buf, desc = "Rename symbol" }
                )
                vim.keymap.set(
                    { "n", "x" },
                    "<Leader>ac",
                    vim.lsp.buf.code_action,
                    { buffer = event.buf, desc = "Code action" }
                )
                vim.keymap.set(
                    "n",
                    "gr",
                    vim.lsp.buf.references,
                    { buffer = event.buf, desc = "List references" }
                )
                vim.keymap.set(
                    "n",
                    "gi",
                    vim.lsp.buf.implementation,
                    { buffer = event.buf, desc = "Go to implementation" }
                )
                vim.keymap.set(
                    "n",
                    "gd",
                    vim.lsp.buf.definition,
                    { buffer = event.buf, desc = "Go to definition" }
                )
                vim.keymap.set(
                    "n",
                    "gD",
                    vim.lsp.buf.declaration,
                    { buffer = event.buf, desc = "Go to declaration" }
                )
                vim.keymap.set(
                    "n",
                    "<Leader>o",
                    vim.lsp.buf.document_symbol,
                    { buffer = event.buf, desc = "List document symbols" }
                )
                vim.keymap.set(
                    "n",
                    "gy",
                    vim.lsp.buf.type_definition,
                    { buffer = event.buf, desc = "Go to type definition" }
                )
                vim.keymap.set(
                    "n",
                    "<C-s>",
                    vim.lsp.buf.signature_help,
                    { buffer = event.buf, desc = "Show signature help" }
                )

                local client = vim.lsp.get_client_by_id(event.data.client_id)
                if not client then
                    return
                end

                if
                    client:supports_method(
                        vim.lsp.protocol.Methods.textDocument_documentHighlight,
                        event.buf
                    )
                then
                    local highlight_augroup =
                        create_augroup("lsp-highlight", { clear = false })
                    vim.api.nvim_create_autocmd(
                        { "CursorHold", "CursorHoldI" },
                        {
                            buffer = event.buf,
                            group = highlight_augroup,
                            callback = vim.lsp.buf.document_highlight,
                        }
                    )
                    vim.api.nvim_create_autocmd(
                        { "CursorMoved", "CursorMovedI" },
                        {
                            buffer = event.buf,
                            group = highlight_augroup,
                            callback = vim.lsp.buf.clear_references,
                        }
                    )
                    vim.api.nvim_create_autocmd("LspDetach", {
                        group = create_augroup("lsp-detach"),
                        callback = function(event2)
                            vim.lsp.buf.clear_references()
                            vim.api.nvim_clear_autocmds({
                                group = highlight_augroup,
                                buffer = event2.buf,
                            })
                        end,
                    })
                end

                if
                    vim.g.enable_inlay_hints
                    and client:supports_method(
                        vim.lsp.protocol.Methods.textDocument_inlayHint,
                        event.buf
                    )
                then
                    vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
                end

                if
                    vim.g.enable_builtin_autocompletion
                    and client:supports_method(
                        vim.lsp.protocol.Methods.textDocument_completion,
                        event.buf
                    )
                then
                    -- NOTE: optionally trigger autocompletion on EVERY keypress. May be slow!
                    local chars = {}
                    for i = 32, 126 do
                        table.insert(chars, string.char(i))
                    end
                    client.server_capabilities.completionProvider.triggerCharacters =
                        chars

                    vim.lsp.completion.enable(
                        true,
                        client.id,
                        event.buf,
                        { autotrigger = true }
                    )
                    vim.keymap.set("i", "<C-Space>", vim.lsp.completion.get, {
                        buffer = event.buf,
                        desc = "Triggers LSP completion in the current buffer",
                    })
                end

                if
                    vim.g.enable_builtin_formatting
                    and client:supports_method(
                        vim.lsp.protocol.Methods.textDocument_formatting,
                        event.buf
                    )
                then
                    local default_format_opts = {
                        bufnr = event.buf,
                        id = client.id,
                        timeout_ms = 1000,
                    }

                    if vim.g.format_on_save then
                        vim.api.nvim_create_autocmd("BufWritePre", {
                            group = create_augroup(
                                "lsp-formatting",
                                { clear = false }
                            ),
                            buffer = event.buf,
                            callback = function()
                                vim.lsp.buf.format(default_format_opts)
                            end,
                            desc = "Format document on save",
                        })
                    end

                    vim.keymap.set({ "n", "v" }, "<C-l>", function()
                        vim.lsp.buf.format(default_format_opts)
                        local mode = vim.api.nvim_get_mode().mode
                        -- NOTE: leave visual mode after range format.
                        if vim.startswith(string.lower(mode), "v") then
                            vim.api.nvim_feedkeys(
                                vim.api.nvim_replace_termcodes(
                                    "<Esc>",
                                    true,
                                    false,
                                    true
                                ),
                                "n",
                                true
                            )
                        end
                    end, {
                        noremap = true,
                        desc = "Format document",
                    })

                    vim.api.nvim_create_user_command("Format", function(args)
                        local range = nil
                        if args.count ~= -1 then
                            local end_line = vim.api.nvim_buf_get_lines(
                                0,
                                args.line2 - 1,
                                args.line2,
                                true
                            )[1]
                            range = {
                                start = { args.line1, 0 },
                                ["end"] = { args.line2, end_line:len() },
                            }
                        end
                        vim.lsp.buf.format({ range = range })
                    end, {
                        nargs = 0,
                        range = true,
                        desc = "Format document",
                    })
                end
            end,
            desc = "Configure LSP behavior when a client attaches",
        })
    end,
}
