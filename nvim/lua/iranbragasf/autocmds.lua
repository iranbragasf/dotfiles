local create_augroup = require("iranbragasf.utils").create_augroup

vim.api.nvim_create_autocmd("TextYankPost", {
    pattern = "*",
    group = create_augroup("highlight-yank"),
    callback = function()
        vim.hl.on_yank()
    end,
})

-- TOOD: keep the splits' size proportion rather than equaly split the screen (`wincmd =`)
vim.api.nvim_create_autocmd("VimResized", {
    pattern = "*",
    group = create_augroup("resize-splits"),
    callback = function()
        local current_tab = vim.fn.tabpagenr()
        vim.cmd("tabdo wincmd =")
        vim.cmd("tabnext " .. current_tab)
    end,
})

local filetype_detect_augroup = create_augroup("filetype-detect")
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    group = filetype_detect_augroup,
    pattern = { "tsconfig*.json", ".eslintrc.json" },
    callback = function()
        vim.opt_local.filetype = "jsonc"
    end,
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    group = filetype_detect_augroup,
    pattern = ".env.*",
    callback = function()
        vim.opt_local.filetype = "sh"
    end,
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    group = filetype_detect_augroup,
    pattern = "*/git/config*",
    callback = function()
        vim.opt_local.filetype = "gitconfig"
    end,
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    group = filetype_detect_augroup,
    pattern = "*/ssh/config*",
    callback = function()
        vim.opt_local.filetype = "sshconfig"
    end,
})
