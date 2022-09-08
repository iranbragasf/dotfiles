local M = {}

M.config = function ()
    local ok, indent_blankline = pcall(require, "indent_blankline")
    if not ok then
        vim.notify("[ERROR] indent-blankline not loaded", vim.log.levels.ERROR)
        return
    end

    indent_blankline.setup {
        filetype_exclude = {
            'help',
            'text',
            'conf',
            'markdown',
            'packer',
            'dbout',
            'gitrebase',
            'gitcommit',
            'undotree',
            'diff'
        },
        buftype_exclude = { 'terminal', 'nofile' }
    }
end

return M
