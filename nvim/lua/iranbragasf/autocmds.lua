local create_augroup = require("iranbragasf.utils").create_augroup

vim.api.nvim_create_autocmd("TextYankPost", {
    pattern = "*",
    group = create_augroup("highlight_yank"),
    callback = function()
        vim.hl.on_yank()
    end,
    desc = "Highlight yanked text",
})

-- TOOD: keep the splits' size proportion rather than equaly split the screen (`wincmd =`)
vim.api.nvim_create_autocmd("VimResized", {
    pattern = "*",
    group = create_augroup("resize_splits"),
    callback = function()
        local current_tab = vim.fn.tabpagenr()
        vim.cmd("tabdo wincmd =")
        vim.cmd("tabnext " .. current_tab)
    end,
    desc = "Preserve split proportions on window resize",
})
