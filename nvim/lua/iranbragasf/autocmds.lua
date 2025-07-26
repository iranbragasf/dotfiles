local create_augroup = function(name)
  return vim.api.nvim_create_augroup("iranbragasf-" .. name, { clear = true })
end

vim.api.nvim_create_autocmd("TextYankPost", {
    pattern = "*",
    group = create_augroup("highlight-yank"),
    callback = function() vim.hl.on_yank() end,
})

vim.api.nvim_create_autocmd("VimResized", {
    pattern = "*",
    group = create_augroup("resize-windows"),
    callback = function() vim.cmd.tabdo("wincmd =") end,
})

local filetype_detect_augroup = create_augroup("filetype-detect")
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    group = filetype_detect_augroup,
    pattern = { "tsconfig*.json", ".eslintrc.json" },
    callback = function() vim.opt_local.filetype = "jsonc" end,
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    group = filetype_detect_augroup,
    pattern = ".env.*",
    callback = function() vim.opt_local.filetype = "sh" end,
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    group = filetype_detect_augroup,
    pattern = "*/git/config*",
    callback = function() vim.opt_local.filetype = "gitconfig" end,
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    group = filetype_detect_augroup,
    pattern = "*/ssh/config*",
    callback = function() vim.opt_local.filetype = "sshconfig" end,
})
