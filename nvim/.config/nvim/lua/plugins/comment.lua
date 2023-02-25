local M = {}

M.config = function()
    local ok, comment = pcall(require, "Comment")
    if not ok then
        vim.notify("[ERROR] Comment.nvim not loaded", vim.log.levels.ERROR)
        return
    end

    comment.setup({
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook()
    })

    local ft = require('Comment.ft')
    ft.set('jsonc', { '//%s', '/*%s*/' })
end

return M
