local create_augroup = require("iranbragasf.utils").create_augroup

vim.api.nvim_create_autocmd("TextYankPost", {
    pattern = "*",
    group = create_augroup("highlight-yank"),
    callback = function()
        vim.hl.on_yank()
    end,
    desc = "Highlight yanked text",
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
    desc = "Preserve split proportions on window resize",
})

local filetype_detect_augroup = create_augroup("filetype-detect")
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    group = filetype_detect_augroup,
    pattern = { "tsconfig*.json", ".eslintrc.json" },
    callback = function()
        vim.opt_local.filetype = "jsonc"
    end,
    desc = "Set filetype to jsonc for tsconfig and eslintrc",
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    group = filetype_detect_augroup,
    pattern = ".env.*",
    callback = function()
        vim.opt_local.filetype = "sh"
    end,
    desc = "Set filetype to sh for .env files",
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    group = filetype_detect_augroup,
    pattern = "*/git/config*",
    callback = function()
        vim.opt_local.filetype = "gitconfig"
    end,
    desc = "Set filetype to gitconfig for git config files",
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    group = filetype_detect_augroup,
    pattern = "*/ssh/config*",
    callback = function()
        vim.opt_local.filetype = "sshconfig"
    end,
    desc = "Set filetype to sshconfig for ssh config files",
})
