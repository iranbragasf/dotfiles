local M = {}

M.config = function ()
    require("indent_blankline").setup {
        filetype_exclude = {
            'help',
            'text',
            'conf',
            'markdown',
            'packer',
            'dbout'
        },
        buftype_exclude = { 'terminal', 'nofile' }
    }
end

return M
