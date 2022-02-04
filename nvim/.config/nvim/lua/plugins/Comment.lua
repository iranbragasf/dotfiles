local M = {}

M.config = function()
    local ok, Comment = pcall(require, "Comment")
    if not ok then
        vim.notify("ERROR: Comment not loaded", vim.log.levels.ERROR)
        return
    end

    local function pre_hook(ctx)
        local U = require('Comment.utils')

        local location = nil
        if ctx.ctype == U.ctype.block then
            location = require('ts_context_commentstring.utils').get_cursor_location()
        elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
            location = require('ts_context_commentstring.utils').get_visual_start_location()
        end

        return require('ts_context_commentstring.internal').calculate_commentstring({
            key = ctx.ctype == U.ctype.line and '__default' or '__multiline',
            location = location
        })
    end

    Comment.setup({ pre_hook = pre_hook })

    local ft = require('Comment.ft')

    ft.set('jsonc', {'//%s', '/*%s*/'})
end

return M
