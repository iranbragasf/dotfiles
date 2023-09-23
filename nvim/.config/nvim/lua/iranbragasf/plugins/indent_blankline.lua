local M = {}

M.config = function ()
    local indent_blankline_ok, indent_blankline = pcall(require, "indent_blankline")
    if not indent_blankline_ok then
        vim.notify("[ERROR] indent-blankline not loaded", vim.log.levels.ERROR)
        return
    end

    indent_blankline.setup({
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
        buftype_exclude = { 'terminal', 'nofile' },
    })
end

return M
