local M = {}

M.config = function()
    local gitsigns_ok, gitsigns = pcall(require, "gitsigns")
    if not gitsigns_ok then
        vim.notify("[ERROR] gitsigns not loaded", vim.log.levels.ERROR)
        return
    end

    gitsigns.setup({
        signs = {
            add          = { text = "▋" },
            change       = { text = "▋" },
            delete       = { text = "▋" },
            topdelete    = { text = "▋" },
            changedelete = { text = "▋" },
            untracked    = { text = "▋" },
        },
        current_line_blame = true,
        current_line_blame_opts = { delay = 250 },
        preview_config = { border = "none" },
        on_attach = function(bufnr)
            local gs = package.loaded.gitsigns

            local function map(mode, l, r, opts)
                opts = opts or {}
                opts.buffer = bufnr
                opts.noremap = true
                vim.keymap.set(mode, l, r, opts)
            end

            map('n', ']h', function()
                if vim.wo.diff then return ']h' end
                vim.schedule(function() gs.next_hunk() end)
                return '<Ignore>'
            end, { expr = true })
            map('n', '[h', function()
                if vim.wo.diff then return '[h' end
                vim.schedule(function() gs.prev_hunk() end)
                return '<Ignore>'
            end, { expr = true })
            map({'n', 'v'}, '<Leader>hs', ':Gitsigns stage_hunk<CR>', { silent = true })
            map({'n', 'v'}, '<Leader>hr', ':Gitsigns reset_hunk<CR>', { silent = true })
            map('n', '<Leader>hS', gs.stage_buffer)
            map('n', '<Leader>hu', gs.undo_stage_hunk)
            map('n', '<Leader>hR', gs.reset_buffer)
            map('n', '<Leader>hp', gs.preview_hunk)
            map('n', '<Leader>hb', function() gs.blame_line({ full=true }) end)
        end
    })
end

return M
