local M = {}

M.config = function()
    local ok, treesitter = pcall(require, "nvim-treesitter.configs")
    if not ok then
        vim.notify("[ERROR] treesitter not loaded", vim.log.levels.ERROR)
        return
    end

    vim.opt.foldmethod = "expr"
    vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

    treesitter.setup {
        ensure_installed = "maintained",
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },
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
        context_commentstring = {
            enable = true,
            enable_autocmd = false -- Necessary for integration with Comment.nvim
        }
    }

    -- TODO: open an issue to let the guys know that it'd be good to make the
    -- borders customizable.
    -- This is the code responsible for it:
    -- https://github.com/nvim-treesitter/playground/blob/deb887b3f49d66654d9faa9778e8949fe0d80bc3/lua/nvim-treesitter-playground/hl-info.lua#L102
    vim.api.nvim_set_keymap("n", "<Leader>ts", ":TSHighlightCapturesUnderCursor<CR>", {noremap = true, silent = true})
end

return M
