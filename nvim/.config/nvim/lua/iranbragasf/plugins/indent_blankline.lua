require("indent_blankline").setup({
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
