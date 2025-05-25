vim.opt.path:append({"**"})
vim.opt.wildignore:append({
    "**/.git/**",
    "**/node_modules/**",
    "**/coverage/**",
    "**/__pycache__/**",
    "*.o"
})
vim.opt.wildignorecase = true
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.mouse = "a"
vim.opt.guicursor = "n-v-c-sm:block,i-ve:ver25,r-o:hor20"
vim.opt.clipboard = "unnamedplus"
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.scrolloff = 5
vim.opt.sidescrolloff = 5
vim.opt.colorcolumn = "80"
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo"
vim.opt.signcolumn = "yes"
vim.opt.wrap = false
vim.opt.completeopt = { "menuone", "noinsert" }
vim.opt.shortmess:append("c")
vim.opt.cursorline = true
vim.opt.laststatus = 3
vim.opt.pumheight = 12

vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
    group = "YankHighlight",
    pattern = '*',
    callback = function()
        vim.highlight.on_yank()
    end,
})

vim.api.nvim_create_augroup('CursorLineInActiveWindow', { clear = true })

vim.api.nvim_create_autocmd("FileType", {
    pattern = "diff",
    callback = function()
        vim.api.nvim_win_set_option(0, "signcolumn", "no")
    end
})

vim.api.nvim_create_augroup('FiletypeDetect', { clear = true })
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    group = "FiletypeDetect",
    pattern = 'tsconfig*.json,.eslintrc.json',
    callback = function()
        vim.api.nvim_buf_set_option(0, "filetype", "jsonc")
    end,
})
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    group = "FiletypeDetect",
    pattern = '.env.*',
    callback = function()
        vim.api.nvim_buf_set_option(0, "filetype", "sh")
    end,
})
vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
    group = "FiletypeDetect",
    pattern = '*/.config/git/*',
    callback = function()
        vim.api.nvim_buf_set_option(0, "filetype", "gitconfig")
    end,
})
