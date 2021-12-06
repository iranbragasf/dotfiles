local M = {}

M.setup = function()
    vim.g.undotree_WindowLayout = 2
    vim.g.undotree_SplitWidth = 30
    vim.g.undotree_DiffAutoOpen = 0
    vim.g.undotree_SetFocusWhenToggle = 1
    vim.g.undotree_TreeVertShape = "│"

    vim.api.nvim_set_keymap("n", "<Leader>u", ":UndotreeToggle<CR>", {noremap = true, silent = true})
end

M.config = function()
    -- Exit if Undotree is the only window left
    vim.cmd([[autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && &filetype == 'undotree' | quit | endif]])
end

return M
