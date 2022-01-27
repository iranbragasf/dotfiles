local M = {}

M.config = function()
    local ok, gitsigns = pcall(require, "gitsigns")
    if not ok then
        vim.notify("ERROR: gitsigns not loaded", vim.log.levels.ERROR)
        return
    end

    gitsigns.setup {
        signs = {
            add          = { text = "▋" },
            change       = { text = "▋" },
            delete       = { text = "▋" },
            topdelete    = { text = "▋" },
            changedelete = { text = "▋" }
        },
        keymaps = {
            noremap = true,

            ['n ]h'] = { expr = true, "&diff ? ']h' : '<Cmd>Gitsigns next_hunk<CR>'"},
            ['n [h'] = { expr = true, "&diff ? '[h' : '<Cmd>Gitsigns prev_hunk<CR>'"},

            ['n <Leader>hs'] = '<Cmd>Gitsigns stage_hunk<CR>',
            ['v <Leader>hs'] = ':Gitsigns stage_hunk<CR>',
            ['n <Leader>hu'] = '<Cmd>Gitsigns undo_stage_hunk<CR>',
            ['n <Leader>hr'] = '<Cmd>Gitsigns reset_hunk<CR>',
            ['v <Leader>hr'] = ':Gitsigns reset_hunk<CR>',
            ['n <Leader>hR'] = '<Cmd>Gitsigns reset_buffer<CR>',
            ['n <Leader>hp'] = '<Cmd>Gitsigns preview_hunk<CR>',
            ['n <Leader>hb'] = '<Cmd>lua require"gitsigns".blame_line({ full=true })<CR>',
            ['n <Leader>hS'] = '<Cmd>Gitsigns stage_buffer<CR>',
            ['n <Leader>hU'] = '<Cmd>Gitsigns reset_buffer_index<CR>',
        },
        current_line_blame = true,
        current_line_blame_opts = { delay = 250 },
        current_line_blame_formatter_opts = { relative_time = true },
        preview_config = { border = vim.g.border }
    }
end

return M
