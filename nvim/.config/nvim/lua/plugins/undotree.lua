local M = {}

M.setup = function()
    vim.g.undotree_WindowLayout = 2
    vim.g.undotree_SplitWidth = 30
    vim.g.undotree_DiffAutoOpen = 0
    vim.g.undotree_SetFocusWhenToggle = 1
    vim.g.undotree_TreeVertShape = "│"

    vim.keymap.set("n", "<Leader>u", ":UndotreeToggle<CR>", {noremap = true, silent = true})
end

M.config = function()
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "undotree",
        callback = function()
            vim.keymap.set("n", "l", "<Plug>UndotreeEnter", { buffer = true })
        end
    })

    -- Exit if Undotree is the only window left
    -- vim.cmd([[autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && &filetype == 'undotree' | quit | endif]])

    vim.api.nvim_create_autocmd("FileType", {
        pattern = { "undotree", "diff" },
        callback = function()
            vim.api.nvim_win_set_option(0, "signcolumn", "no")
        end
    })
end

return M
