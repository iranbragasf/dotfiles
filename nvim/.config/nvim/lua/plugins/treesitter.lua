local M = {}

M.config = function()
    -- Treesitter based folding. It overrides folding settings in `settings.lua`
    vim.opt.foldmethod = "expr"
    vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

    require('nvim-treesitter.configs').setup {
        ensure_installed = "maintained",
        sync_install = false,
        highlight = { enable = true },
        playground = {
            enable = true,
            disable = {},
            updatetime = 25,
            persist_queries = false,
            keybindings = {
                toggle_query_editor = 'o',
                toggle_hl_groups = 'i',
                toggle_injected_languages = 't',
                toggle_anonymous_nodes = 'a',
                toggle_language_display = 'I',
                focus_language = 'f',
                unfocus_language = 'F',
                update = 'R',
                goto_node = '<CR>',
                show_help = '?'
            }
        },
        query_linter = {
            enable = true,
            use_virtual_text = true,
            lint_events = { "BufWrite", "CursorHold" }
        },
    }

    vim.api.nvim_set_keymap("n", "<Leader>ts", ":TSHighlightCapturesUnderCursor<CR>", {noremap = true, silent = true})
end

return M
