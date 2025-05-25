vim.api.nvim_create_autocmd("FileType", {
    pattern = "undotree",
    callback = function()
        vim.keymap.set("n", "l", "<Plug>UndotreeEnter", { buffer = true })
    end
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "undotree",
    callback = function()
        vim.api.nvim_win_set_option(0, "signcolumn", "no")
    end
})
