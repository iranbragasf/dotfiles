return {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    keys = {
        {
            "<Leader>u",
            ":UndotreeToggle<CR>",
            noremap = true,
            silent = true,
            desc = "Toggle undotree panel",
        },
    },
    init = function()
        vim.g.undotree_WindowLayout = 2
        vim.g.undotree_DiffAutoOpen = 0
        vim.g.undotree_SetFocusWhenToggle = 1
        vim.g.undotree_TreeNodeShape = ""
        vim.g.undotree_TreeReturnShape = "╲"
        vim.g.undotree_TreeVertShape = "│"
        vim.g.undotree_TreeSplitShape = "╱"
        vim.g.undotree_SignAdded = "+"
        vim.g.undotree_SignChanged = "~"
        vim.g.undotree_SignDeleted = "-"
        vim.g.undotree_SignDeletedEnd = "-"
    end,
    config = function()
        vim.api.nvim_create_autocmd("FileType", {
            pattern = { "undotree", "diff" },
            callback = function()
                vim.opt_local.signcolumn = "no"
            end,
        })
    end,
}
